//
//  PGBarChartDataModel.h
//
//  Created by piggybear on 2016/11/29.
//  Copyright © 2016年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGBarChartDataModel : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *unit;

- (instancetype)initWithLabel:(NSString *)label value:(CGFloat)vaule index:(NSInteger)index unit:(NSString *)unit;
@end
