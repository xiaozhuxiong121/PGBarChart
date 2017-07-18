//
//  PGBox.m
//
//  Created by piggybear on 2016/11/29.
//  Copyright © 2016年 piggybear. All rights reserved.
// GitHub Address: https://github.com/xiaozhuxiong121/PGBarChart

#import "PGBox.h"

@implementation PGBox

- (instancetype)initWithPosition:(CGPoint)point value:(CGFloat)value unit:(NSString *)unit title:(NSString *)title {
    self = [self initWithFrame:CGRectMake(point.x, point.y, 100, 100)];
    if (self) {
        _title = title;
        _value = value;
        _unit = unit;
        
        self.text = [self makeString];;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self setFont:[UIFont systemFontOfSize:10.0f]];
        [self setTextColor: [UIColor whiteColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        
        [self sizeToFit];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = [super sizeThatFits:size];
    resultSize = CGSizeMake(resultSize.width + 8, resultSize.height + 4);
    return resultSize;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    self.text = [self makeString];
}

- (NSString *)makeString {
    NSString *finalText = nil;
    if (_title) {
        [self setNumberOfLines:2];
        if (_unit) {
            finalText = [_title stringByAppendingString:[[NSString stringWithFormat:@"\n%.1f ", _value] stringByAppendingString:_unit]];
        }
        else {
            finalText = [_title stringByAppendingString:[NSString stringWithFormat:@"\n%.1f", _value]];
        }
    }
    else {
        [self setNumberOfLines:1];
        if (_unit) {
            finalText = [[NSString stringWithFormat:@"%.1f ", _value] stringByAppendingString:_unit];
        }
        else {
            finalText = [NSString stringWithFormat:@"%.1f", _value];
        }
    }
    
    return finalText;
}

@end
