//
//  UILabel+AutoSize.m
//  PictPerfect
//
//  Created by Adya on 11/02/2015.
//  Copyright (c) 2015 vvteam. All rights reserved.
//

#import "UILabel+AutoSize.h"

@implementation UILabel (AutoSize)

-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:UILineBreakModeWordWrap];
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,CGFLOAT_MAX);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.height;
}

@end
