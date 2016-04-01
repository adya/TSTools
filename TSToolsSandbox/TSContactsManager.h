/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [6.0; 9.0)
 *  Date:       ../../2015
 *  Status:     Outdated, Undocumented
 *  
 *  Dependency: @framework AddressBook
 *
 *  Description:
 *
 *  TSContactsManager loads asynchronously contacts and brings it to you through delegate and readonly property.
 *  In order to set it up you need to do the following:
 *      1. Set accessDelegate to handle accessing to contacts.
 *      2. Set progressDelegate to handle reading progress.
 *      3. Call 'refresh' method start async loading of contacts.
 *      4. After first loading, get contacts array from any place through contactsBook property
 *
 *  Note: You can call refresh in any time to update contacts.
 *
 */

#import <Foundation/Foundation.h>

@class TSContact;
@class UIImage;

/** Specifies callbacks for process of grantig access to contacts. */
@protocol TSContactManagerAccessDelegate <NSObject>

/** */
-(void) onRequestAccessResult:(BOOL)result wasDenied:(BOOL) wasDenied;

@end

@protocol TSContactManagerProgressDelegate <NSObject>

@optional -(void) onReadingContactsHasStarted:(int) totalAmount;
@optional -(void) onReadingContactsProgress:(nonnull TSContact*) readContact current:(int) currentAmount of:(int) totalAmount;

@optional -(void) onReadingContactsHasFinished:(nonnull NSArray<TSContact*>*) contacts;
@end

@interface TSContactsManager : NSObject

+ (nonnull instancetype) sharedManager;

@property (readonly, nonnull) NSArray<TSContact*>* contactsBook;

@property (weak, nullable) id<TSContactManagerAccessDelegate> accessDelegate;

@property (weak, nullable) id<TSContactManagerProgressDelegate> progressDelegate;

@property (readonly) BOOL isLoaded;

-(void) refresh;

@end

typedef NS_ENUM(NSInteger, TSPhoneType){
    TS_PHONE_TYPE_NONE,
    TS_PHONE_TYPE_MOBILE,
    TS_PHONE_TYPE_IPHONE,
    TS_PHONE_TYPE_MAIN,
    TS_PHONE_TYPE_HOME_FAX,
    TS_PHONE_TYPE_WORK_FAX,
    TS_PHONE_TYPE_OTHER_FAX,
    TS_PHONE_TYPE_PAGER
};

@interface TSPhone : NSObject

@property (nonnull) NSString* number;
@property TSPhoneType type;
@end

@interface NSArray (TSPhone)

-(nullable TSPhone*) phoneWithType:(TSPhoneType) type;

@end


@interface TSContact : NSObject

@property (nullable) NSString* firstName;
@property (nullable) NSString* lastName;
@property (nullable) NSString* middleName;

@property (readonly, nullable) NSString* fullName;

@property (nullable) NSString* email;
@property (nullable) NSArray<NSString*>*  auxEmails;

@property (nullable) TSPhone* phone;
@property (nullable) NSArray* auxPhones;

@property (nullable) UIImage* picture;
@end