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

@property (nonatomic) NSCharacterSet* _Nonnull invalidInputCharacterSet;
@property (nonatomic) NSNumberFormatter* _Nonnull currencyNumberFormatter;

@property (nonatomic) NSNumber* _Nonnull amount;
@property (nonatomic, assign) NSUInteger maximumLength;

@end
