
#import "UILabel+AutoSize.h"

@implementation UILabel (AutoSize)

-(CGFloat) resizeToFitWithMaxHeight:(CGFloat) maxHeight {
    float height = [self expectedHeightWithMaxHeight:maxHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(CGFloat) expectedHeightWithMaxHeight:(CGFloat)maxHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize maximumLabelSize = CGSizeMake(self.bounds.size.width, maxHeight);
    CGFloat height = [self.text boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: self.font} context:nil].size.height;
    return height;
}

-(CGFloat) resizeToFit {
    return [self resizeToFitWithMaxHeight:CGFLOAT_MAX];
}

-(CGFloat) expectedHeight {
    return [self expectedHeightWithMaxHeight:CGFLOAT_MAX];
}

@end
