//
//  TSContactsManager.h
//  CelcoinUsuario
//
//  Created by Adya on 7/28/15.
//  Copyright (c) 2015 Adya. All rights reserved.
//

// Usage:
// 1. Set delegates.
// 2. Call -(void) refresh.
// 3. Read contacts through @property NSArray* contactsBook;

#import <Foundation/Foundation.h>

@class TSContact;

@protocol TSContactManagerAccessDelegate <NSObject>

-(void) onRequestAccessResult:(BOOL)result wasDenied:(BOOL) wasDenied;

@end

@protocol TSContactManagerProgressDelegate <NSObject>

@optional -(void) onReadingContactsHasStarted:(int) totalAmount;
@optional -(void) onReadingContactsProgress:(TSContact*) readContact current:(int) currentAmount of:(int) totalAmount;

@optional -(void) onReadingContactsHasFinished:(NSArray*) contacts;
@end

@interface TSContactsManager : NSObject

+ (TSContactsManager*) sharedManager;

@property (readonly) NSArray* contactsBook;

@property id<TSContactManagerAccessDelegate> accessDelegate;

@property id<TSContactManagerProgressDelegate> progressDelegate;

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

@property NSString* number;
    @property TSPhoneType type;
@end

@interface NSArray (TSPhone)

-(TSPhone*) phoneWithType:(TSPhoneType) type;

@end


@interface TSContact : NSObject

    @property NSString* firstName;
    @property NSString* lastName;
    @property NSString* middleName;

@property (readonly) NSString* fullName;

    @property NSString* email;
    @property NSArray* auxEmails;

    @property TSPhone* phone;
    @property NSArray* auxPhones;

    @property UIImage* picture;
@end