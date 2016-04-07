/**
 *  Author:     Unknown
 *  Version:    1.5
 *  iOS:        2.0+
 *  Date:       02/16/2016
 *  Status:     Outdated
 *
 *  Dependency: None
 *
 *  Description:
 *
 * UItextField subclass which allows to format text with custom NSNumberFormatter object.
 *
 *  TODO: Clean this up and refactor.
 *
 */

#import <UIKit/UIKit.h>

@interface TSCurrencyTextField : UITextField

@property (nonatomic, nonnull) NSCharacterSet* invalidInputCharacterSet;
@property (nonatomic, nonnull) NSNumberFormatter* currencyNumberFormatter;

@property (nonatomic, nonnull) NSNumber* amount;
@property (nonatomic, assign) NSUInteger maximumLength;

@end
