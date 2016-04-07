#import "TSPurchaseManagerProtected.h"
#import <StoreKit/StoreKit.h>

#import "TSError.h"

@interface TSPurchaseManager() <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end

static NSString* const STORED_TRANSACTIONS = @"TSIAPReceipt";

@implementation TSPurchaseManager{
    NSDictionary* productsDictionary; // contains product with identifiers.
}

@synthesize delegate, initDelegate;

-(nonnull NSArray<TSProduct*>*) products{
    return  [productsDictionary allValues];
}

+(instancetype) sharedManager {
    static TSPurchaseManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{manager = [[self alloc] init];});
    return manager;
}

-(void) startManager{
    [[SKPaymentQueue defaultQueue] addTransactionObserver : self];
}

-(void) stopManager{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver : self];
}

-(BOOL) isReady{
    return productsDictionary.count > 0;
}

-(void) loadProducts{
    NSSet* ids = [self loadProductsIdentifiers];
    if (ids.count == 0) {
        NSLog(@"Products identifiers weren't specified.");
        return;
    }
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:ids];
    request.delegate = self;
    [request start];
}

#pragma mark - TSPurchaseManagerProtected

-(TSProduct*) processProduct:(SKProduct*) product {
    TSProduct* pr = [TSProduct new];
    pr.underlyingProduct = product;
    return pr;
}

-(NSSet*) loadProductsIdentifiers {
    return [NSSet new];
}

-(TSProduct*) productWithIdentifier:(NSString *)identifier{
    return [productsDictionary objectForKey:identifier];
}

-(BOOL) purchaseProductWithIdentifier:(NSString *)productIdentifier{
    TSProduct* product = [self productWithIdentifier:productIdentifier];
    if (product && product.underlyingProduct) {
        [self purchaseProduct:product];
    }
    else{
        if ([delegate respondsToSelector:@selector(onPurchasingProduct:failedWithError:)])
            [delegate onPurchasingProduct:nil failedWithError:[TSError errorWithCode:TS_ERROR_INTERNAL andTitle:@"Can't find product with given identifier"]];
        NSLog(@"%@ : %@ (%@)", self.class, @"Can't find product with given identifier", productIdentifier);
    }
    return (product != nil);
}

-(void) purchaseProduct:(TSProduct*) product{
    if (productsDictionary.count == 0) {
        if ([delegate respondsToSelector:@selector(onPurchasingProduct:failedWithError:)])
            [delegate onPurchasingProduct:nil failedWithError:[TSError errorWithCode:TS_ERROR_INTERNAL andTitle:@"Products weren't loaded"]];
        NSLog(@"%@ : %@", self.class, @"Products weren't loaded.");
        return;
    }
    if (product.underlyingProduct) {
        if ([delegate respondsToSelector:@selector(onPurchasingProduct:failedWithError:)])
            [delegate onPurchasingProduct:nil failedWithError:[TSError errorWithCode:TS_ERROR_INTERNAL andTitle:@"Invalid product"]];
        NSLog(@"%@ : %@", self.class, @"Invalid product passed to purchaseProduct:");
        return;
    }
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product.underlyingProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



-(void) savePayment:(SKPaymentTransaction*) transaction{
    if (transaction.transactionState != SKPaymentTransactionStateRestored &&
        transaction.transactionState != SKPaymentTransactionStatePurchased) return;
    
    NSString* productId = transaction.payment.productIdentifier;
    NSDictionary *savedTransactions = [self storedTransactions];
    if (!savedTransactions) {
        [self saveTransactions:@{transaction.transactionIdentifier : productId}];
    } else {
        NSMutableDictionary *updatedTransactions = [NSMutableDictionary dictionaryWithDictionary:savedTransactions];
        [updatedTransactions setObject:productId forKey:transaction.transactionIdentifier];
        [self saveTransactions:updatedTransactions];
    }
    if ([delegate respondsToSelector:@selector(onPurchasingProduct:recordSavedWithTransactionId:)])
        [delegate onPurchasingProduct: [self productWithIdentifier:transaction.payment.productIdentifier] recordSavedWithTransactionId:transaction.transactionIdentifier];
    NSLog(@"%@ : Finishing transaction associated with %@", self.class, transaction.payment.productIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void) productsRequest:(SKProductsRequest*) request didReceiveResponse:(SKProductsResponse*) response{
    if (response.products.count == 0){
        if ([initDelegate respondsToSelector:@selector(onFailedLoadingProductsWithError:)])
            [initDelegate onFailedLoadingProductsWithError:[TSError errorWithCode:TS_ERROR_PURCHASE title:@"Failed to load products" andDescription:@"App Store responsed with error"]];
    }
    else{
        NSMutableDictionary* tmpProducts = [NSMutableDictionary new];
        for (SKProduct* prod in response.products) {
            [tmpProducts setObject:[self processProduct:prod] forKey:prod.productIdentifier];
        }
        productsDictionary = [NSDictionary dictionaryWithDictionary:tmpProducts];
        if ([initDelegate respondsToSelector:@selector(onProductsLoaded:)])
            [initDelegate onProductsLoaded:[productsDictionary allValues]];
    }
}

-(void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    if ([delegate respondsToSelector:@selector(onPurchasesRestoredWithProducts:)])
        [delegate onPurchasesRestoredWithProducts:@[]];
    NSLog(@"%@ : Restored!", self.class);
}

-(void) paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"%@ : Restoring Failed!", self.class);
}

-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction*>*) transactions{
    for (SKPaymentTransaction* transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                if ([delegate respondsToSelector:@selector(onPurchasingProduct:failedWithError:)])
                    [delegate onPurchasingProduct:[self productWithIdentifier:transaction.payment.productIdentifier] failedWithError:[TSError errorWithNSError:transaction.error]];
                break;
            case SKPaymentTransactionStateRestored:
            case SKPaymentTransactionStatePurchased:
                [self savePayment:transaction];
                if ([delegate respondsToSelector:@selector(onPurchasingProduct:completedWithTransactionId:restored:)])
                    [delegate onPurchasingProduct:[self productWithIdentifier:transaction.payment.productIdentifier] completedWithTransactionId:transaction.transactionIdentifier restored:transaction.transactionState == SKPaymentTransactionStateRestored];
                break;
            case SKPaymentTransactionStatePurchasing:
                if ([delegate respondsToSelector:@selector(onPurchasingProduct:processingWithTransactionId:defered:)])
                    [delegate onPurchasingProduct:[self productWithIdentifier:transaction.payment.productIdentifier] processingWithTransactionId:transaction.transactionIdentifier defered:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                if ([delegate respondsToSelector:@selector(onPurchasingProduct:processingWithTransactionId:defered:)])
                    [delegate onPurchasingProduct:[self productWithIdentifier:transaction.payment.productIdentifier] processingWithTransactionId:transaction.transactionIdentifier defered:YES];
                break;
            default: NSLog(@"%@ : This should never be the case..", self.class);
                break;
        }
    }
}

-(NSDictionary*) storedTransactions{
    NSUserDefaults* storage = [NSUserDefaults standardUserDefaults];
    return [storage dictionaryForKey:STORED_TRANSACTIONS];
}

-(NSDictionary*) storedTransactionsFiltererWithProductIdentifiers:(NSSet*) ids{
    NSDictionary* dic = [self storedTransactions];
    NSMutableDictionary* coinsDic = [NSMutableDictionary new];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if ([ids containsObject:obj])
            [coinsDic setObject:obj forKey:key];
    }];
    return [NSDictionary dictionaryWithDictionary:coinsDic];
}

-(void) saveTransactions:(NSDictionary*) transactions{
    NSUserDefaults* storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:transactions forKey:STORED_TRANSACTIONS];
    [storage synchronize];
}

-(BOOL) hasStoredPayments{
    return ([self storedTransactions].count > 0);
}

-(void) restorePurchases{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void) restorePayments:(NSDictionary*) payments{
    NSMutableArray<TSProduct*>* productsRestored = [NSMutableArray new];
    [payments enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        TSProduct* prod = [self productWithIdentifier:obj];
        [productsRestored addObject:prod];
        if ([delegate respondsToSelector:@selector(onPurchasingProduct:completedWithTransactionId:restored:)])
            [delegate onPurchasingProduct:prod completedWithTransactionId:key restored:YES];
    }];

    if ([delegate respondsToSelector:@selector(onPurchasesRestoredWithProducts:)])
        [delegate onPurchasesRestoredWithProducts:[NSArray arrayWithArray:productsRestored]];
}

-(void) restorePayments{
    [self restorePayments:[self storedTransactions]];
}

-(void) approvePurchase:(NSString *)transactionId{
    NSMutableDictionary* transactions = [[NSMutableDictionary alloc] initWithDictionary:[self storedTransactions]];
    [transactions removeObjectForKey:transactionId];
    [self saveTransactions:transactions];
}
@end

#pragma mark - TSProduct code.

@interface SKProduct (LocalizedPrice)
-(NSString*) localizedPrice;
@end

@implementation SKProduct (LocalizedPrice)

-(NSString*) localizedPrice{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.locale = self.priceLocale;
    return [formatter stringFromNumber: self.price];
}

@end

@implementation TSProduct{
    SKProduct* underlyingProduct;
}

-(SKProduct*) underlyingProduct {return underlyingProduct; }
-(void) setUnderlyingProduct:(SKProduct *)_underlyingProduct{underlyingProduct = _underlyingProduct;}

-(NSString*) localizedTitle { return underlyingProduct.localizedTitle; }
-(NSString*) localizedDescription { return underlyingProduct.localizedDescription; }
-(NSString*) localizedPrice {return underlyingProduct.localizedPrice; }
-(NSDecimalNumber*) price { return underlyingProduct.price; }
-(NSLocale*) priceLocale { return underlyingProduct.priceLocale; }
-(NSString*) productIdentifier { return underlyingProduct.productIdentifier; }
-(BOOL) isDownloadable { return underlyingProduct.isDownloadable; }
-(NSArray<NSNumber*>*) downloadContentLengths { return underlyingProduct.downloadContentLengths; }
-(NSString*) downloadContentVersion { return underlyingProduct.downloadContentVersion; }

@end