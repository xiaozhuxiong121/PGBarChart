//
//  PGBarChartDataModel.m
//
//  Created by piggybear on 2016/11/29.
//  Copyright © 2016年 piggybear. All rights reserved.
// GitHub Address: https://github.com/xiaozhuxiong121/PGBarChart

#import "PGBarChartDataModel.h"

@implementation PGBarChartDataModel

- (instancetype)initWithLabel:(NSString *)label value:(CGFloat)vaule index:(NSInteger)index unit:(NSString *)unit {
    
    if ([self init]) {
        _unit  = unit;
        _label = label;
        _value = vaule;
        _index = index;
    }
    return self;
}

@end
