//
//  PGBar.h
//
//  Created by piggybear on 2016/11/29.
//  Copyright © 2016年 piggybear. All rights reserved.
// GitHub Address: https://github.com/xiaozhuxiong121/PGBarChart

#import <UIKit/UIKit.h>
@class PGBarChartDataModel;
@class PGBar;

@protocol PGBarDelegate <NSObject>

- (void)barTaped:(PGBar *)bar;

@end

typedef NS_ENUM(NSUInteger, PGBarAnimationType) {
    PGBarAnimationDefault,
    PGBarAnimationLinear,
    PGBarAnimationEaseIn,
    PGBarAnimationEaseOut,
    PGBarAnimationEaseInEaseOut
};

typedef NS_ENUM(NSUInteger, PGBarLineCap) {
    PGBarLineCapCapButt,
    PGBarLineCapRound,
    PGBarLineCapSquare,
};

@interface PGBar : UIView

@property (nonatomic, assign) CGFloat grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@property (nonatomic, strong) PGBarChartDataModel *barChartDataModel;

@property (nonatomic, strong) id <PGBarDelegate> delegate;

/**
 *  线帽
 */
@property(nonatomic, assign) PGBarLineCap lineCap;
/**
 *  动画类型
 */
@property(nonatomic, assign) PGBarAnimationType animationType;

- (void)rollBack;
-(void)grade:(CGFloat)grade animationType:(PGBarAnimationType)animationType;

@end
