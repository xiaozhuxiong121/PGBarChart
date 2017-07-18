//
//  PGBarChart.m
//
//  Created by piggybear on 2016/11/29.
//  Copyright © 2016年 piggybear. All rights reserved.
// GitHub Address: https://github.com/xiaozhuxiong121/PGBarChart

#import "PGBarChart.h"

#define VerticalLabelGapLine 5
#define VerticalLineGap 5

@interface PGBarChart()

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, PGBar *> *bars;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, PGBarChartLabel *> *barChartLabels;
@property (nonatomic, strong) NSMutableArray<PGBarChartLabel *> *verticalLabels;
@property (nonatomic, strong) NSMutableArray<UIView *> *horizontalLines;
@property (nonatomic, weak) UIView *verticalLine;
@property (nonatomic, weak) UIView *bottomLine;

@end

#define PGColor(r,g,b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]

@implementation PGBarChart

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _barChartLabels = [NSMutableDictionary dictionary];
        _bars = [NSMutableDictionary dictionary];
        _verticalLabels = [NSMutableArray array];
        _horizontalLines = [NSMutableArray array];
        
        self.barWidth = 10;
        self.barNormalColor = PGColor(58, 137, 217);
        self.bottomLabelFontSize = 13;
        self.bottomLineColor = PGColor(150, 150, 150);
        self.verticalFontColor = PGColor(150, 150, 150);
        self.verticalFontSize = 12;
        self.bottomLineHeight = 1;
        self.bottomLineColor = PGColor(225, 225, 225);
        self.leftBackgroundColor = PGColor(225, 225, 225);
        self.leftLineWidth = 1;
        self.horizontalLineHeight = 1;
        self.horizontalLineBackgroundColor = PGColor(225, 225, 225);
        self.animationType = PGBarAnimationEaseInEaseOut;
        self.lineCap = PGBarLineCapCapButt;
    }
    return self;
}


#pragma mark Setter and Getter

- (void)setLineCap:(PGBarLineCap)lineCap {
    _lineCap = lineCap;
    [self.bars enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, PGBar * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.lineCap = lineCap;
    }];
}

- (void)setAnimationType:(PGBarAnimationType)animationType {
    _animationType = animationType;
    
    NSArray *datas = [self.dataSource charDataModels];
    if (datas.count != 0) {
        float maxValue = [self maxValueForCharDataModels].value * 1.1;
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PGBarChartDataModel *dataModel = [self valueForIndex:idx];
            PGBar *bar = self.bars[[NSNumber numberWithInteger:idx]];
            bar.barColor = self.barNormalColor;
            [bar grade:dataModel.value / maxValue animationType:animationType];
            bar.barChartDataModel = dataModel;
        }];
    }
}

- (void)setDataSource:(id<PGBarChartDataSource>)dataSource {
    _dataSource = dataSource;
    [self logic];
}

- (void)setHorizontalLineBackgroundColor:(UIColor *)horizontalLineBackgroundColor {
    _horizontalLineBackgroundColor = horizontalLineBackgroundColor;
    [self.horizontalLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = horizontalLineBackgroundColor;
    }];
}

- (void)setHorizontalLineHeight:(CGFloat)horizontalLineHeight {
    _horizontalLineHeight = horizontalLineHeight;
    [self.horizontalLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = obj.frame.origin.x;
        CGFloat y = obj.frame.origin.y;
        CGFloat width = obj.frame.size.width;
        obj.frame = CGRectMake(x, y, width, horizontalLineHeight);
    }];
}

- (void)setLeftBackgroundColor:(UIColor *)leftBackgroundColor {
    _leftBackgroundColor = leftBackgroundColor;
    self.verticalLine.backgroundColor = leftBackgroundColor;
}

- (void)setLeftLineWidth:(CGFloat)leftLineWidth {
    _leftLineWidth = leftLineWidth;
    CGFloat x = self.verticalLine.frame.origin.x;
    CGFloat y = self.verticalLine.frame.origin.y;
    CGFloat height = self.verticalLine.frame.size.height;
    self.verticalLine.frame = CGRectMake(x, y, leftLineWidth, height);
}

- (void)setBarWidth:(CGFloat)barWidth {
    _barWidth = barWidth;
    [_bars enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PGBar * obj, BOOL * _Nonnull stop) {
        CGFloat x = obj.frame.origin.x;
        CGFloat y = obj.frame.origin.y;
        CGFloat height = obj.frame.size.height;
        obj.frame = CGRectMake(x, y, barWidth, height);
    }];
    
    [_barChartLabels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PGBarChartLabel * obj, BOOL * _Nonnull stop) {
        CGFloat y = obj.frame.origin.y;
        CGSize size = obj.frame.size;
        CGSize fontSize = [obj.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.bottomLabelFontSize]}];
        PGBar *bar = _bars[key];
        obj.frame = CGRectMake(bar.frame.origin.x + barWidth/2 - fontSize.width/2, y, size.width, size.height);
    }];
}

- (void)setBottomLabelFontSize:(NSUInteger)bottomLabelFontSize {
    _bottomLabelFontSize = bottomLabelFontSize;
    [_barChartLabels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PGBarChartLabel * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.fontSize = bottomLabelFontSize;
        CGSize originalSize = [obj.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:bottomLabelFontSize]}];
        CGFloat x = obj.frame.origin.x + originalSize.width/2;
        CGFloat y = obj.frame.origin.y;
        CGFloat width = obj.frame.size.width;
        CGSize size = [obj.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:bottomLabelFontSize]}];
        obj.frame = CGRectMake(x - size.width/2, y, width, size.height);
    }];
}

- (void)setBottomLabelFontColor:(UIColor *)bottomLabelFontColor {
    _bottomLabelFontColor = bottomLabelFontColor;
    [_barChartLabels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PGBarChartLabel * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.fontColor = bottomLabelFontColor;
    }];
}

- (void)setVerticalFontColor:(UIColor *)verticalFontColor {
    _verticalFontColor = verticalFontColor;
    [self.verticalLabels enumerateObjectsUsingBlock:^(PGBarChartLabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.fontColor = verticalFontColor;
    }];
}

- (void)setVerticalFontSize:(NSUInteger)verticalFontSize {
    _verticalFontSize = verticalFontSize;
    
    [self.verticalLabels enumerateObjectsUsingBlock:^(PGBarChartLabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.fontSize = verticalFontSize;
        CGFloat width = [obj.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:verticalFontSize]}].width;
        CGFloat height = obj.frame.size.height;
        CGFloat x = 10;
        CGFloat y = obj.frame.origin.y;
        obj.frame = CGRectMake(x, y, width, height);
    }];
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    self.bottomLine.backgroundColor = bottomLineColor;
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight {
    _bottomLineHeight = bottomLineHeight;
    CGFloat x = self.bottomLine.frame.origin.x;
    CGFloat y = self.bottomLine.frame.origin.y;
    CGFloat width = self.bottomLine.frame.size.width;
    self.bottomLine.frame = CGRectMake(x, y, width, bottomLineHeight);
}

- (void)setBarNormalColor:(UIColor *)barNormalColor {
    _barNormalColor = barNormalColor;
    [self.bars enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, PGBar * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.barColor = barNormalColor;
    }];
}

#pragma -mark- Custom Methed

- (PGBarChartDataModel *)maxValueForCharDataModels {
    NSArray *data = [_dataSource charDataModels];
    CGFloat maxValue = [[data valueForKeyPath:@"@max.value.floatValue"] floatValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.value = %f", maxValue];
    NSArray *array = [data filteredArrayUsingPredicate:predicate];
    return array[0];
}

- (PGBarChartDataModel *)valueForIndex:(NSInteger)index {
    NSArray *data = [_dataSource charDataModels];
    if (index >= [data count] || index < 0) return nil;
    return [data objectAtIndex:index];
}

-(void)rollBackAnimation {
    [self.bars enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, PGBar * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj rollBack];
    }];
}

- (void)reloadData {
    NSArray *datas = [self.dataSource charDataModels];
    float maxValue = [self maxValueForCharDataModels].value * 1.1;
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PGBarChartDataModel *dataModel = [self valueForIndex:idx];
        PGBar *bar = self.bars[[NSNumber numberWithInteger:idx]];
        bar.barColor = self.barNormalColor;
        [bar grade:dataModel.value / maxValue animationType:self.animationType];
        bar.barChartDataModel = dataModel;
    }];
}

- (CGFloat)setupLineAndVerticalLabel {
    CGFloat maxHeight = [self dataModelsMaxHeight];
    float heightGap = (self.frame.size.height - maxHeight - VerticalLineGap) / 10.0;
    
    float highestValueEColumnChart = [self maxValueForCharDataModels].value * 1.1;
    float valueGap = highestValueEColumnChart / 10.0;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 11; i++) {
        NSString *text = [[NSString stringWithFormat:@"%.f", valueGap * (10 - i)] stringByAppendingString:[self maxValueForCharDataModels].unit];
        CGFloat textWidth = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.verticalFontSize]}].width;
        
        CGRect frame = CGRectMake(10, -heightGap / 2.0 + heightGap * i, textWidth, heightGap);
        PGBarChartLabel *eColumnChartLabel = [[PGBarChartLabel alloc] initWithFrame:frame];
        [eColumnChartLabel setTextAlignment:NSTextAlignmentLeft];
        eColumnChartLabel.fontColor = self.verticalFontColor;
        eColumnChartLabel.fontSize = self.verticalFontSize;
        [array addObject:[NSNumber numberWithFloat:(textWidth + 10)]];
        eColumnChartLabel.text = [[NSString stringWithFormat:@"%.f", valueGap * (10 - i)] stringByAppendingString:[self maxValueForCharDataModels].unit];
        //eColumnChartLabel.backgroundColor = ELightBlue;
        [self addSubview:eColumnChartLabel];
        [self.verticalLabels addObject:eColumnChartLabel];
    }
    
    CGFloat maxValue = [[array valueForKeyPath:@"@max.self.floatValue"] floatValue];
    return maxValue + VerticalLabelGapLine;
}

- (CGFloat)dataModelsMaxHeight {
    NSMutableArray *array = [NSMutableArray array];
    [[_dataSource charDataModels] enumerateObjectsUsingBlock:^(PGBarChartDataModel * dataModel, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize dataModelSize = [dataModel.label sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.bottomLabelFontSize]}];
        [array addObject:[NSNumber numberWithFloat:dataModelSize.height]];
    }];
    
    CGFloat maxHeight = [[array valueForKeyPath:@"@max.self.floatValue"] floatValue];
    return maxHeight;
}

- (void)logic {
    CGFloat verticalLinePoX = [self setupLineAndVerticalLabel];
    NSInteger totalCount = [self.dataSource charDataModels].count;
    float maxValue = [self maxValueForCharDataModels].value * 1.1;
    CGFloat gap = (self.frame.size.width - verticalLinePoX - totalCount * self.barWidth) / (totalCount + 1);
    CGFloat maxHeight = [self dataModelsMaxHeight];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(verticalLinePoX, self.frame.size.height - maxHeight - VerticalLineGap, self.frame.size.width, self.bottomLineHeight)];
    
    //   UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(verticalLinePoX + gap, self.frame.size.height - maxHeight - VerticalLineGap, gap*(totalCount - 1) + self.barWidth * totalCount, self.bottomLineHeight)];
    
    bottomLine.backgroundColor = self.bottomLineColor;
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(verticalLinePoX, 0, self.leftLineWidth, self.frame.size.height - maxHeight - VerticalLineGap)];
    verticalLine.backgroundColor = self.leftBackgroundColor;
    [self addSubview:verticalLine];
    self.verticalLine = verticalLine;
    float heightGap = bottomLine.frame.origin.y / 10.0;
    for (int i = 0; i < 11; i++) {
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(verticalLinePoX, heightGap * i, self.frame.size.width, self.horizontalLineHeight)];
        horizontalLine.backgroundColor = self.horizontalLineBackgroundColor;
        [self addSubview:horizontalLine];
        [self.horizontalLines addObject:horizontalLine];
    }
    
    for (int i = 0; i < totalCount; i++) {
        NSInteger currentIndex = i;
        PGBarChartDataModel *dataModel = [self valueForIndex:currentIndex];
        CGSize dataModelSize = [dataModel.label sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.bottomLabelFontSize]}];
        CGFloat barPosX = verticalLinePoX + gap + i * (gap + self.barWidth);
        
        PGBar *bar = [[PGBar alloc] initWithFrame:CGRectMake(barPosX, 3, self.barWidth, self.frame.size.height-3 - maxHeight - VerticalLineGap)];
        bar.lineCap = self.lineCap;
        bar.barColor = self.barNormalColor;
        bar.backgroundColor = [UIColor clearColor];
        [bar grade:dataModel.value / maxValue animationType:self.animationType];
        bar.barChartDataModel = dataModel;
        bar.barColor = self.barNormalColor;
        [bar setDelegate:self];
        [self addSubview:bar];
        [self.bars setObject:bar forKey:[NSNumber numberWithInteger:currentIndex]];
        
        CGRect frame = CGRectMake(barPosX + self.barWidth/2 - dataModelSize.width/2,
                                  self.frame.size.height - maxHeight,
                                  dataModelSize.width,
                                  dataModelSize.height);
        PGBarChartLabel *barChartLabel = [[PGBarChartLabel alloc]initWithFrame:frame];
        barChartLabel.fontSize = self.bottomLabelFontSize;
        barChartLabel.fontColor = self.bottomLabelFontColor;
        [barChartLabel setTextAlignment:NSTextAlignmentCenter];
        barChartLabel.text = dataModel.label;
        //eColumnChartLabel.backgroundColor = ELightBlue;
        [self addSubview:barChartLabel];
        [self.barChartLabels setObject:barChartLabel forKey:[NSNumber numberWithInteger:(currentIndex)]];
    }
}

#pragma -mark- EColumnDelegate

- (void)barTaped:(PGBar *)bar {
    [_delegate barChart:self didSelectBar:bar];
}

@end
