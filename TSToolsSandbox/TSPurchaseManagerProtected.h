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
 *  This header file is used for inheritance of TSPurchaseManager and has definitions of methods valid only in derived classes.
 */

#import "TSPurchaseManager.h"
#import <StoreKit/SKProduct.h>

@interface TSPurchaseManager (Inheritance)

/**
 This method is called for every product fetched from App Store.
 Override it to customize product processing.
 @return Returns SKProduct wrapper derived from TSProduct. 
 */
-(nonnull TSProduct*) processProduct:(nonnull SKProduct*) product;

/**
 Loads a set of product identifiers which will be fetched from App Store.
 @return Returns NSSet object containing identifiers of all needed products.
 */
-(nonnull NSSet*) loadProductsIdentifiers;

/**
 Retrieves all transactions which weren't approved.
 @return Returns dictionary of transactiondId - productId pairs.
 */
-(nonnull NSDictionary*) storedTransactions;

/**
 Restores only given transactions.
 */
-(void) restorePayments:(nonnull NSDictionary*) paymetns;

/**
 Retrieves transactions which weren't approved filtered with specified NSSet of product identifiers.
 @return Returns dictionary of transactiondId - productId pairs, contained only those productIds which exists in specified set.
 */
-(nonnull NSDictionary*) storedTransactionsFiltererWithProductIdentifiers:(nonnull NSSet*) ids;

@end

@interface TSProduct (Inheritance)
@property SKProduct* _Nonnull underlyingProduct;
@end