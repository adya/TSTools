/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        2.0+
 *  Date:       ../../2015
 *  Status:     Completed, Undocumented
 *
 *  Dependency: None
 *
 *  Description:
 *
 *  UILabel's AutoSize extension provides method to resize label's height to fit text.
 */

#import <UIKit/UIKit.h>

@interface UILabel (AutoSize)

    /// Resize label's height to fit text.
-(CGFloat) resizeToFit;

    /// Resize label's height to fit text, but not bigger than maxHeight.
-(CGFloat) resizeToFitWithMaxHeight:(CGFloat) maxHeight;

    /// Calculates height to fit text.
-(CGFloat) expectedHeight;

    /// Calculates height to fit text not bigger than maxHeight.
-(CGFloat) expectedHeightWithMaxHeight:(CGFloat) maxHeight;

@end
