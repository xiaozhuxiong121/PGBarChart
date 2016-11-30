//
//  ViewController.m
//  demo
//
//  Created by piggybear on 2016/11/30.
//  Copyright © 2016年 piggybear. All rights reserved.
//

#import "ViewController.h"
#import "PGBarChart.h"

@interface ViewController ()<PGBarChartDelegate, PGBarChartDataSource>

@property (weak, nonatomic) IBOutlet UIView *customView;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) PGBarChart *barChart;
@property (nonatomic, strong) PGBox *box;

@end

#define PGColor(r,g,b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tempData];
    [self setupChart];
}

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

//如果想要滑动的话 将PGBarChart放到UIScrollView即可
- (void)setupChart {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.customView.frame];
    CGRect frame = CGRectMake(0, 5, self.customView.bounds.size.width * 1.5, self.customView.bounds.size.height - 5);
    PGBarChart *barChart = [[PGBarChart alloc] initWithFrame:frame];
    
    barChart.barNormalColor = PGColor(58, 137, 217);
    barChart.barWidth = 10;
    barChart.bottomLabelFontSize = 12;
    barChart.bottomLabelFontColor = PGColor(150, 150, 150);
    barChart.verticalFontColor = PGColor(150, 150, 150);
    barChart.verticalFontSize = 12;
    barChart.bottomLineHeight = 1;
    barChart.bottomLineColor = PGColor(225, 225 ,225);
    barChart.leftLineWidth = 1;
    barChart.leftBackgroundColor = PGColor(230, 230, 230);
    barChart.horizontalLineHeight = 1;
    barChart.horizontalLineBackgroundColor = PGColor(230, 230, 230);
    
    [barChart setDelegate:self];
    [barChart setDataSource:self];
    
    //    [self addSubview:barChart];
    
    scrollView.contentSize = CGSizeMake(barChart.frame.size.width, 0);
    [scrollView addSubview:barChart];
    scrollView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:scrollView];
    self.barChart = barChart;
}

//不滑动的效果
- (void)setupChart2 {
    PGBarChart *barChart = [[PGBarChart alloc] initWithFrame:self.customView.frame];
    barChart.barNormalColor = PGColor(58, 137, 217);
    barChart.barWidth = 10;
    barChart.bottomLabelFontSize = 12;
    barChart.bottomLabelFontColor = PGColor(150, 150, 150);
    barChart.verticalFontColor = PGColor(150, 150, 150);
    barChart.verticalFontSize = 12;
    barChart.bottomLineHeight = 1;
    barChart.bottomLineColor = PGColor(225, 225 ,225);
    barChart.leftLineWidth = 1;
    barChart.leftBackgroundColor = PGColor(230, 230, 230);
    barChart.horizontalLineHeight = 1;
    barChart.horizontalLineBackgroundColor = PGColor(230, 230, 230);
    [barChart setDelegate:self];
    [barChart setDataSource:self];
    [self.view addSubview:barChart];
    self.barChart = barChart;
}

- (void)updateTempData {
    [self.data enumerateObjectsUsingBlock:^(PGBarChartDataModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = 10 + arc4random() % 30;
        obj.value = value;
    }];
}

- (void)tempData {
    [self.data removeAllObjects];
    NSArray *data = @[@"王\n大\n雷", @"张\n军", @"高\n雄", @"张\n小\n林", @"张\n松",
                      @"李\n伟", @"王\n伟", @"张\n勇", @"张\n宇", @"张\n盛"];
    
    for (int i = 0; i < 10; i++) {
        int value = 10 + arc4random() % 30;
        PGBarChartDataModel *dataModel = [[PGBarChartDataModel alloc] initWithLabel:data[i] value:value index:i unit:@"台次"];
        [self.data addObject:dataModel];
    }
}

- (IBAction)buttonAction:(id)sender {
    [self updateTempData];
    [self.barChart reloadData];
}

- (IBAction)button2Action:(id)sender {
    if (self.barChart.lineCap != PGBarLineCapRound) {
        self.barChart.lineCap = PGBarLineCapRound;
    }else {
        self.barChart.lineCap = PGBarLineCapCapButt;
    }
}

#pragma mark PGBarChartDataSource

- (NSArray *)charDataModels {
    return self.data;
}

#pragma mark PGBarChartDelegate

- (void) barChart:(PGBarChart *)barChart didSelectBar:(PGBar *)bar {
    NSLog(@"Index: %ld  Value: %f", (long)bar.barChartDataModel.index, bar.barChartDataModel.value);
    CGFloat eFloatBoxX = bar.frame.origin.x - 10;
    CGFloat eFloatBoxY = bar.frame.origin.y + bar.frame.size.height * (1 - bar.grade);
    
    if (_box) {
        [_box removeFromSuperview];
        _box.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _box.frame.size.width, _box.frame.size.height);
        [_box setValue:bar.barChartDataModel.value];
        [barChart addSubview:_box];
    }
    else {
        _box = [[PGBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:bar.barChartDataModel.value unit:@"台次" title:nil];
        _box.alpha = 0.0;
        [barChart addSubview:_box];
    }
    eFloatBoxY -= (_box.frame.size.height + bar.frame.size.width * 0.25);
    _box.frame = CGRectMake(eFloatBoxX, eFloatBoxY, 50, 30);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _box.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        if (_box) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                _box.alpha = 0.0;
                _box.frame = CGRectMake(_box.frame.origin.x, _box.frame.origin.y + _box.frame.size.height, _box.frame.size.width, _box.frame.size.height);
            } completion:^(BOOL finished) {
                [_box removeFromSuperview];
                _box = nil;
            }];
        }
    }];

}

@end
