//
//  PGBarChartLabel.m
//
//  Created by piggybear on 2016/11/29.
//  Copyright © 2016年 piggybear. All rights reserved.
// GitHub Address: https://github.com/xiaozhuxiong121/PGBarChart

#import "PGBarChartLabel.h"

@implementation PGBarChartLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self setLineBreakMode:NSLineBreakByClipping];
        self.adjustsFontSizeToFitWidth = YES;
        [self setMinimumScaleFactor:5.0f/13.0f];
        [self setNumberOfLines:0];
        [self setFont:[UIFont systemFontOfSize:12.0f]];
        [self setTextColor: [UIColor darkGrayColor]];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        self.userInteractionEnabled = YES;
        [self setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    }
    return self;
}

-(void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self setFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
    [self setTextColor:fontColor];
}

@end
