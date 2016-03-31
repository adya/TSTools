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

+ (instancetype) sharedManager;

@property (readonly) NSArray<TSContact*>* _Nonnull contactsBook;

@property id<TSContactManagerAccessDelegate> _Nullable accessDelegate;

@property id<TSContactManagerProgressDelegate> _Nullable progressDelegate;

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

@property NSString* _Nonnull number;
@property TSPhoneType type;
@end

@interface NSArray (TSPhone)

-(nullable TSPhone*) phoneWithType:(TSPhoneType) type;

@end


@interface TSContact : NSObject

@property NSString* _Nullable firstName;
@property NSString* _Nullable lastName;
@property NSString* _Nullable middleName;

@property (readonly) NSString* _Nonnull fullName;

@property NSString* _Nullable email;
@property NSArray<NSString*>* _Nullable auxEmails;

@property TSPhone* _Nonnull phone;
@property NSArray* _Nonnull auxPhones;

@property UIImage* _Nullable picture;
@end