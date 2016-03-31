#import "TSCurrencyTextField.h"

@interface TSCurrencyTextFieldDelegate : NSObject <UITextFieldDelegate>
@property (weak, nonatomic) id<UITextFieldDelegate> delegate;
@end

@implementation TSCurrencyTextField
{
    TSCurrencyTextFieldDelegate* _currencyTextFieldDelegate;

    NSNumberFormatter*           _currencyNumberFormatter;

    NSCharacterSet*              _invalidInputCharacterSet;
}

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super initWithCoder: aDecoder];
    if ( self )
    {
        [self TSCurrencyTextField_commonInit];
    }
    return self;
}

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if ( self )
    {
        [self TSCurrencyTextField_commonInit];
    }
    return self;
}

- (void) TSCurrencyTextField_commonInit
{
    _invalidInputCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    _currencyNumberFormatter = [[NSNumberFormatter alloc] init];
    _currencyNumberFormatter.locale = [NSLocale currentLocale];
    _currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    _currencyNumberFormatter.usesGroupingSeparator = YES;
    
    _currencyTextFieldDelegate = [TSCurrencyTextFieldDelegate new];
    [super setDelegate: _currencyTextFieldDelegate];
    
    _maximumLength = 0;
    [self setText: @"0"];
}

- (void) setCaratPosition: (NSInteger) pos
{
    [self setSelectionRange: NSMakeRange( pos, 0) ];
}

- (void) setSelectionRange: (NSRange) range
{
    UITextPosition *start = [self positionFromPosition: [self beginningOfDocument]
                                                offset: range.location];
    
    UITextPosition *end = [self positionFromPosition: start
                                              offset: range.length];
    
    [self setSelectedTextRange: [self textRangeFromPosition:start toPosition:end]];
}

- (void) setAmount: (NSNumber *) amount
{
    NSString* amountString = [NSString stringWithFormat: @"%.*lf", (int)_currencyNumberFormatter.maximumFractionDigits, amount.doubleValue];
    [self setText: amountString];
}

- (NSNumber*) amountFromString: (NSString*) string
{
    NSString* digitString = [[string componentsSeparatedByCharactersInSet: _invalidInputCharacterSet] componentsJoinedByString: @""];
    
    NSParameterAssert( _currencyNumberFormatter.maximumFractionDigits == _currencyNumberFormatter.minimumFractionDigits );
    NSInteger fd = _currencyNumberFormatter.minimumFractionDigits;
    NSNumber* n = [NSNumber numberWithDouble: [digitString doubleValue] / pow(10.0, fd) ];
    
    return n;
}

- (NSNumber*) amount
{
    return [self amountFromString: self.text];
}

- (void) setDelegate:(id<UITextFieldDelegate>)delegate
{
    _currencyTextFieldDelegate.delegate = delegate;
}

- (id<UITextFieldDelegate>) delegate
{
    return _currencyTextFieldDelegate.delegate;
}

- (void) setText: (NSString *) text
{
    NSString* formatted = [_currencyNumberFormatter stringFromNumber: [self amountFromString: text]];
    
    [super setText: formatted];
}

@end

@implementation TSCurrencyTextFieldDelegate

/// Forward any implemented UITextFieldDelegate method, other than the one we implement ourself.
- (BOOL) respondsToSelector: (SEL) aSelector {
    return [super respondsToSelector: aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (id) forwardingTargetForSelector: (SEL) aSelector {
    if ([self.delegate respondsToSelector: aSelector])
        return self.delegate;
    else return nil;
}

- (BOOL) textField: (TSCurrencyTextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string
{
    // "deleting" a formatting character just back-spaces over that character:
    if ( string.length == 0 && range.length == 1 && [[textField invalidInputCharacterSet] characterIsMember: [textField.text characterAtIndex: range.location]] )
    {
        [textField setCaratPosition: range.location];
        return NO;
    }
    
    NSUInteger distanceFromEnd = textField.text.length - (range.location + range.length);
    
    NSString* changed = [textField.text stringByReplacingCharactersInRange: range withString: string];
    if (textField.maximumLength > 0 && changed.length > textField.maximumLength)
            return NO;
    
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
        if ([self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string])
                       [textField setText:changed];
    }
    else
        [textField setText:changed];
    NSInteger pos = textField.text.length - distanceFromEnd;
    if ( pos >= 0 && pos <= textField.text.length )
    {
        [textField setCaratPosition: pos];
    }
    
    [textField sendActionsForControlEvents: UIControlEventEditingChanged];
    return NO;
}

@end