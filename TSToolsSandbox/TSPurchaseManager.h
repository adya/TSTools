/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        3.0+
 *  Date:       03/25/2016
 *  Status:     New
 *
 *  Dependency: @framework StoreKit,
 *              @header TSError
 *
 *  Description:
 *
 *  TSPurchaseManager designed to handle purchasing process in a nice convinient way. It, also, provides safe purchases. This means that all receipts of completed purchases are immidiately stored until they won't be approved. In this way it won't lose any purchases unless they will have successfully handled.
 *
 *  In order to set it up you need to do the following:
 *      1. Inherit TSPurchaseManager using TSPurchaseManagerProtected.h header file.
 *      2. Override its' loadProductsIdentifiers to add products.
 *      3. (Optional) override processProduct to use custom product wrappers for better usability.
 *      4. (Optional) Set TSPurchaseManagerInitDelegate delegate in order to receive initialization events.
 *      5. Set TSPurchaseManagerDelegate delegate in order to handle purchasing events.
 *      6. Put startManager in AppDelegate's application:didFinishLaunchingWithOptions: method.
 *      7. Put stopManager in AppDelegate's applicationWillTerminate: method.
 *      8. Once, you are set, call loadProducts to fetch available list of products from App Store.
 *
 *  Note: 6 step should be done in AppDelegate upon app starts (not mandatorily, but strngly recommended to follow Apple's best practices guide.)
 *
 *  To handle purchasing you should do:
        1. Implement methods required by TSPurchaseManagerDelegate protocol.
 *      2. Call either purchaseProduct: or purchaseProductWithIdentifier: to start purchasing process.
 *      3. To check is there any failed purchases use 'hasStoredPayments' method.
 *      4. If there are such purchases you can restore them by calling restorePayments.
 *      5. To complete purchasing you should call approvePurchase: with current transactionsId to mark it as succesfully handled.
 *      6. You can request restoring of purchases from App Store by calling restorePurchases.
 *
 *  You can define custom products categories in derived classes by customizing property 'products' and methods 'hasStoredPayments' and 'restorePayments'.
 *  @seealso TSPurchaseManagerProtected.h header file for more customization options.
 */

#import <Foundation/Foundation.h>

@class TSError;
@class TSProduct;

/** Delegate responsible for handling purchase process. */
@protocol TSPurchaseManagerDelegate <NSObject>

/** Called when purchasing of specified product has failed.
 * Required.
 * @param product Product which had been purschasing.
 * @param error Occured error.
 */
@required -(void) onPurchasingProduct:(nullable TSProduct*) product failedWithError:(nonnull TSError*) error;

/** Called when purchasing completed succesfully.
 * Required.
 * @param product Purchased product.
 * @param transactionId Reference to related transaction.
 * @param isRestored flag indicating whether this transaction was restored or it is original.
 */
@required -(void) onPurchasingProduct:(nonnull TSProduct*) product
           completedWithTransactionId:(nonnull NSString*) transactionId
                             restored:(BOOL) isRestored;


/** Called when resoring purchases completed. 
 *  Optional.
 *  @param products array of purchased products.
 */
@optional -(void) onPurchasesRestoredWithProducts:(nonnull NSArray<TSProduct*>*) products;

/** Called during processing of transaction. Used for notifying user about purchasing status.
 *  Optional.
 *  @param product Processing product.
 *  @param transactionId Related transaction.
 *  @param isDeferred Flag indicating wether transaction has been deferred.
 */
@optional -(void) onPurchasingProduct:(nonnull TSProduct*) product
          processingWithTransactionId:(nonnull NSString*) transactionId
                              defered:(BOOL) isDeferred;

/** Called right after purchase has been completed and payment has been stored.
 *  Optional.
 *  @param product Purchased product.
 *  @param transactionId Related transaction.
 */
@optional -(void) onPurchasingProduct:(nonnull TSProduct*) product
         recordSavedWithTransactionId:(nonnull NSString*) transactionId;
@end

/** Delegate responsible for handling manager initialization. */
@protocol TSPurchaseManagerInitDelegate <NSObject>

/** Called when products has been fetched from AppStore. */
-(void) onProductsLoaded:(nonnull NSArray<TSProduct*>*) products;

/** Called when loading products failed. */
-(void) onFailedLoadingProductsWithError:(nonnull TSError*) error;

@end

@interface TSPurchaseManager : NSObject

+(nonnull instancetype) sharedManager;

@property (weak, nullable) id<TSPurchaseManagerDelegate> delegate;
@property (weak, nullable) id<TSPurchaseManagerInitDelegate> initDelegate;
@property (readonly, nonnull) NSArray<TSProduct*>* products;
@property (readonly, nonnull) NSArray<NSString*>* productsIdentifiers;

/** Initializes manager. */
-(void) startManager;

/** Clears purchase observer. */
-(void) stopManager;

/** Fetches list of available products from App Store. */
-(void) loadProducts;

/**
 Gets product with specified identifier.
 @return Returns either product with specified identifier or nil if no such products.
 */
-(nullable TSProduct*) productWithIdentifier:(nonnull NSString*) identifier;


/** Purchases given product. */
-(void) purchaseProduct:(nonnull TSProduct*) product;

/**
 Purchases product with given identifier.
 @return Returns flag indicating whether product was found and purchase process was started or not.
 */
-(BOOL) purchaseProductWithIdentifier:(nonnull NSString*) productIdentifier;

/** Approves that purchase was handled and successfully recorded/used and can be removed. */
-(void) approvePurchase:(nonnull NSString*) transactionId;

/** Checks is there any purchases that wasn't approved. */
-(BOOL) hasStoredPayments;

/** Gets all products which were previously purchased, but wasn't handled and removed from that list. */
-(void) restorePayments;

/** Triggers Restoring of purchases. */
-(void) restorePurchases;

@end

#pragma mark TSProduct code.

/** Wrapper of SKProduct class designed to allow subclassing of SKProduct and therefore further customization. */
@interface TSProduct: NSObject 
    @property(readonly, nonnull) NSString* localizedDescription NS_AVAILABLE_IOS(3_0);
    @property(readonly, nonnull) NSString* localizedTitle NS_AVAILABLE_IOS(3_0);
    @property(readonly, nonnull) NSString* localizedPrice NS_AVAILABLE_IOS(3_0);
    @property(readonly, nonnull) NSDecimalNumber* price NS_AVAILABLE_IOS(3_0);
    @property(readonly, nonnull) NSLocale* priceLocale NS_AVAILABLE_IOS(3_0);
    @property(readonly, nonnull) NSString* productIdentifier NS_AVAILABLE_IOS(3_0);
    @property(readonly, getter=isDownloadable) BOOL downloadable NS_AVAILABLE_IOS(6_0);
    @property(readonly, nonnull) NSArray<NSNumber*>* downloadContentLengths NS_AVAILABLE_IOS(6_0);
    @property(readonly, nonnull) NSString* downloadContentVersion NS_AVAILABLE_IOS(6_0);

@end
