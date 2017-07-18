//
//  PGBar.m
//
//  Created by piggybear on 2016/11/29.
//  Copyright © 2016年 piggybear. All rights reserved.
// GitHub Address: https://github.com/xiaozhuxiong121/PGBarChart

#import "PGBar.h"

@implementation PGBar

@synthesize barColor = _barColor;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _chartLine              = [CAShapeLayer layer];
        _chartLine.lineCap      = kCALineCapButt;
        _chartLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth    = self.frame.size.width;
        _chartLine.strokeEnd    = 0.0;
        self.clipsToBounds      = YES;
		[self.layer addSublayer:_chartLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setLineCap:(PGBarLineCap)lineCap {
    _lineCap = lineCap;
    switch (lineCap) {
        case PGBarLineCapCapButt:
            _chartLine.lineCap = kCALineCapButt;
            break;
        case PGBarLineCapRound:
            _chartLine.lineCap = kCALineCapRound;
            break;
        case PGBarLineCapSquare:
            _chartLine.lineCap = kCALineCapSquare;
            break;
    }
}

- (void)setGrade:(CGFloat)grade {
    _grade = grade;
    [self grade:grade animationType:PGBarAnimationEaseInEaseOut];
}

-(void)grade:(CGFloat)grade animationType:(PGBarAnimationType)animationType {
    _grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height)];
	
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;
    _chartLine.strokeEnd = 1.0;
	if (self.barColor) {
		_chartLine.strokeColor = [self.barColor CGColor];
	}else{
		_chartLine.strokeColor = [[UIColor greenColor] CGColor];
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:[self animationName:animationType]];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

- (void)setBarColor:(UIColor *)barColor {
    _chartLine.strokeColor = [barColor CGColor];
}

- (UIColor *)barColor {
    return [UIColor colorWithCGColor:_chartLine.strokeColor];
}

- (NSString *)animationName:(PGBarAnimationType)animationType {
    NSString *name = @"";
    switch (self.animationType) {
        case PGBarAnimationDefault:
            name = kCAMediaTimingFunctionDefault;
            break;
        case PGBarAnimationLinear:
            name = kCAMediaTimingFunctionLinear;
            break;
        case PGBarAnimationEaseIn:
            name = kCAMediaTimingFunctionEaseIn;
            break;
        case PGBarAnimationEaseOut:
            name = kCAMediaTimingFunctionEaseOut;
            break;
        case PGBarAnimationEaseInEaseOut:
            name = kCAMediaTimingFunctionEaseInEaseOut;
            break;
    }
    return name;
}

-(void)rollBack {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _chartLine.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
	CGContextFillRect(context, rect);
}

#pragma -mark- detect Geusture

- (void) taped:(UITapGestureRecognizer *)tapGesture {
    [_delegate barTaped:self];
}

@end
