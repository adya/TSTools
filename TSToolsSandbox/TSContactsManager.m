#import "TSContactsManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface TSContactsManager (ReadingAddressBook)
-(void) requestAccess;
@end

@implementation TSContactsManager{
    NSArray* contactsBook;
}

-(NSArray*) contactsBook{
    return contactsBook;
}

@synthesize accessDelegate;
@synthesize progressDelegate;

-(BOOL) isLoaded{
    return contactsBook != nil;
}

+ (instancetype) sharedManager{
    static TSContactsManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{manager = [[self alloc] init];});
    return manager;
}

-(void) refresh{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self requestAccess];
    });
}

@end

@implementation TSContactsManager (ReadingAddressBook)

-(void) requestAccess{
    CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    ABAddressBookRef addressBookRef;
    if(iOSVersion >= 6.0) {
        // Request authorization to Address Book
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted){
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.accessDelegate onRequestAccessResult:YES wasDenied:NO];
                    });
                    [self readContacts:addressBookRef];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.accessDelegate onRequestAccessResult:NO wasDenied:NO];
                    });
                }
                if(addressBookRef) CFRelease(addressBookRef);
            });
        } // The user has previously given access, add the contact
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.accessDelegate onRequestAccessResult:YES wasDenied:NO];
            });
            [self readContacts:addressBookRef];
            if(addressBookRef) CFRelease(addressBookRef);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.accessDelegate onRequestAccessResult:NO wasDenied:YES];
            });
            if(addressBookRef) CFRelease(addressBookRef);
        }
    } else {
        addressBookRef = ABAddressBookCreate();
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.accessDelegate onRequestAccessResult:YES wasDenied:NO];
        });
        [self readContacts:addressBookRef];
        if(addressBookRef) CFRelease(addressBookRef);
    }
}

-(void) readContacts:(ABAddressBookRef)book{
    CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(book);
    NSArray *contacts = (__bridge NSArray*)records;
    CFRelease(records);
    NSUInteger total = contacts.count;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if ([self.progressDelegate respondsToSelector:@selector(onReadingContactsHasStarted:)])
                [self.progressDelegate onReadingContactsHasStarted:(int)total];
        });
        
        NSMutableArray* tmpContactsBook = [NSMutableArray new];
        for(int i = 0; i < total; i++) {
            ABRecordRef record = (__bridge ABRecordRef)[contacts objectAtIndex:i];
            TSContact* c = [TSContact new];
            c.firstName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
            c.middleName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonMiddleNameProperty));
            c.lastName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty));
            c.auxEmails = [self getEmailsFromRecord:record];
            if (c.auxEmails.count > 0) c.email = [c.auxEmails objectAtIndex:0];
            
            c.auxPhones = [self getPhonesFromRecord:record];
            if (c.auxPhones.count > 0) c.phone = [c.auxPhones phoneWithType:TS_PHONE_TYPE_MAIN];
            
            c.picture = [self getPictureFromRecord:record];
            [tmpContactsBook addObject:c];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if ([self.progressDelegate respondsToSelector:@selector(onReadingContactsProgress:current:of:)])
                    [self.progressDelegate onReadingContactsProgress:c current:i of:(int)total];
            });
            
        }
        
        contactsBook = [NSArray arrayWithArray:tmpContactsBook];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if ([self.progressDelegate respondsToSelector:@selector(onReadingContactsHasFinished:)])
                [self.progressDelegate onReadingContactsHasFinished:contactsBook];
        });
   
}

-(UIImage*) getPictureFromRecord:(ABRecordRef) record{
    if (record && ABPersonHasImageData(record)) {
        if ( &ABPersonCopyImageDataWithFormat != nil ) {
            return [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail)];
        }
        else return nil;
    } else return nil;
}

-(NSArray*) getEmailsFromRecord:(ABRecordRef) record{
    ABMutableMultiValueRef emailsRef  = ABRecordCopyValue(record, kABPersonEmailProperty);
    if(emailsRef) {
        CFIndex count = ABMultiValueGetCount(emailsRef);
        if (count == 0) return nil;
        
        NSMutableArray* emails = [NSMutableArray new];
        for (CFIndex i = 0; i < count; ++i) {
            [emails addObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(emailsRef, i)];
        }
        return [NSArray arrayWithArray:emails];
    }
    else return nil;
}

-(NSArray*) getPhonesFromRecord:(ABRecordRef) record{
    ABMultiValueRef phonesRef    = ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    if(phonesRef) {
        CFIndex count = ABMultiValueGetCount(phonesRef);
        if (count == 0) return nil;
        
        NSMutableArray* phones = [NSMutableArray new];
        for(CFIndex ix = 0; ix < count; ix++){
            CFStringRef typeRef = ABMultiValueCopyLabelAtIndex(phonesRef, ix);
            CFStringRef numberRef = ABMultiValueCopyValueAtIndex(phonesRef, ix);
            
            NSString *phoneNumber = (__bridge NSString *)numberRef;
            NSString *phoneType = (__bridge NSString *)typeRef;
            
            TSPhone* p = [TSPhone new];
            p.number = phoneNumber;
            p.type = [self getPhoneTypeFromString:phoneType];
            
            [phones addObject:p];
            
            if(numberRef) CFRelease(numberRef);
            if(typeRef) CFRelease(typeRef);
        }
        CFRelease(phonesRef);
        return [NSArray arrayWithArray:phones];
    }
    else return nil;
}

-(TSPhoneType) getPhoneTypeFromString:(NSString*) stringType{
    if ([stringType isEqualToString:(NSString*)kABPersonPhoneMobileLabel])
        return TS_PHONE_TYPE_MOBILE;
    else if ([stringType isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
        return TS_PHONE_TYPE_IPHONE;
    else if ([stringType isEqualToString:(NSString*)kABPersonPhoneMainLabel])
        return TS_PHONE_TYPE_MAIN;
    else if ([stringType isEqualToString:(NSString*)kABPersonPhoneHomeFAXLabel])
        return TS_PHONE_TYPE_HOME_FAX;
    else if ([stringType isEqualToString:(NSString*)kABPersonPhoneWorkFAXLabel])
        return TS_PHONE_TYPE_WORK_FAX;
    else if ([stringType isEqualToString:(NSString*)kABPersonPhoneOtherFAXLabel])
        return TS_PHONE_TYPE_OTHER_FAX;
    else if ([stringType isEqualToString:(NSString*)kABPersonPhonePagerLabel])
        return TS_PHONE_TYPE_PAGER;
    else
        return TS_PHONE_TYPE_NONE;
}

@end


@implementation TSPhone

@synthesize number;
@synthesize type;

@end

@implementation NSArray (TSPhone)

-(TSPhone*) phoneWithType:(TSPhoneType)type{
    for (TSPhone* p in self) {
        if (p.type == type)
            return p;
    }
    return nil;
}

@end

@implementation TSContact

@synthesize firstName, lastName, middleName, phone, auxPhones, email, auxEmails, picture;

-(NSString*) fullName{
    if ((firstName && firstName.length > 0) && (lastName && lastName.length > 0))
        return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    else if (firstName && firstName.length > 0)
        return firstName;
    else if (lastName && lastName.length > 0)
        return lastName;
    else
        return nil;
}

@end
