//
//  LDEasyChart.m
//  实用简单的图表
//
//  Created by ld on 16/1/20.
//  Copyright © 2016年 kingpoint. All rights reserved.
//

#import "LDEasyChart.h"
#import "LDChart.h"

@interface LDEasyChart()<LDChartDataSource,LDChartDelegate>
{
    NSArray  * _values;
    NSArray  * _times;
    NSString * _titleX;
    NSString * _titleY;
    NSString * _titleMain;
}

@property (weak, nonatomic)  LDChart *chartTable;
@property (weak, nonatomic) IBOutlet UILabel *tips;

/**
 图表的滚动view容器
 */
@property (weak, nonatomic) IBOutlet UIScrollView *ChartContentView;
@end

@implementation LDEasyChart

+(instancetype)easyChart
{
    return [[[NSBundle mainBundle]loadNibNamed:@"LDEasyChart" owner:self options:nil]lastObject];
}

- (void)awakeFromNib {
    //设置表格的代理和数据源
    LDChart * chart = [LDChart new];
    _chartTable = chart;
    _chartTable.delegate = self;
    _chartTable.dataSource = self;
    [self.ChartContentView addSubview:_chartTable];
}

-(void)drawChartWithValues:(NSArray *)values times:(NSArray *)times
{
    _values = values;
    _times = times;
    //设置是否显示无数据lable
    self.tips.hidden = values.count;
    //调整图表和滚动view的大小
    _chartTable.frame = self.bounds;
    CGRect frame = _chartTable.frame;
    frame.size.width = self.gapX * _values.count + 50;
    _chartTable.frame = frame;
    self.ChartContentView.contentSize = CGSizeMake(self.gapX*_values.count + 20 , 0);
    [self.chartTable reDraw];
}
-(NSInteger)gapX
{
    return _gapX?_gapX:80;
}
#pragma mark - 表格的基本设置
//图标点的间距
-(NSInteger)gap
{
    return self.gapX;
}
//返回点的个数
-(NSInteger)numberForChart:(LDChart *)chart
{
    return _values.count;
}

//返回对应位置点的值
-(NSInteger)chart:(LDChart *)chart valueAtIndex:(NSInteger)index
{
    return [_values[index] integerValue];;
}
//返回对应位置是时间
-(NSString *)chart:(LDChart *)chart timeAtIndex:(NSInteger)index{
    return _times[index];
}
//点击对应点的事件传递
-(void)chart:(LDChart *)view didClickPointAtIndex:(NSInteger)index value:(NSInteger)value{
    if (self.dataBlock) {
        self.dataBlock(index,value);
    }
}

//这是个画坐标的
-(void)drawRect:(CGRect)rect{
    CGFloat margin = 13.;
    //绘制坐标
    UIBezierPath *coordinate=[UIBezierPath bezierPath];
    [coordinate moveToPoint:CGPointMake(1.5*margin, 1.5*margin)];
    [coordinate addLineToPoint:CGPointMake(1.5*margin, self.frame.size.height-1.5*margin - 20)];
    [coordinate addLineToPoint:CGPointMake(self.frame.size.width-margin, self.frame.size.height-1.5*margin - 20)];
    
    [coordinate stroke];
    
    UIBezierPath *arrowsForY=[UIBezierPath bezierPath];
    [arrowsForY moveToPoint:CGPointMake(margin, margin*2)];
    [arrowsForY addLineToPoint:CGPointMake(1.5*margin, 1.5*margin)];
    [arrowsForY addLineToPoint:CGPointMake(margin*2, margin*2)];
    [arrowsForY stroke];
    
    UIBezierPath *arrowsForX=[UIBezierPath bezierPath];
    [arrowsForX moveToPoint:CGPointMake(self.frame.size.width-(margin*1.5), self.frame.size.height-(margin*2)-20)];
    [arrowsForX addLineToPoint:CGPointMake(self.frame.size.width-margin, self.frame.size.height-1.5*margin-20)];
    [arrowsForX addLineToPoint:CGPointMake(self.frame.size.width-(margin*1.5), self.frame.size.height-(margin*1)-20)];
    [arrowsForX stroke];
    
    //画x,y轴的title和顶部title
    NSDictionary * attDic = @{
                              NSFontAttributeName:[UIFont systemFontOfSize:13]
                              };
    [_titleX drawWithRect:CGRectMake(rect.size.width - 47, rect.size.height - 25, 30, 20) options:NSStringDrawingUsesDeviceMetrics attributes:attDic context:nil];
    [_titleY drawWithRect:CGRectMake(7, 13, 40, 20) options:NSStringDrawingUsesDeviceMetrics attributes:attDic context:nil];
    [_titleMain drawWithRect:CGRectMake(rect.size.width * 0.5 - 50, 13, 100, 30) options:NSStringDrawingUsesDeviceMetrics attributes:attDic context:nil];
}

//设置x，y，和顶部 的title
-(void)setTitleX:(NSString *)titleX titleY:(NSString *)titleY titleMain:(NSString *)titleMain
{
    _titleX = titleX;
    _titleY = titleY;
    _titleMain = titleMain;
}

@end
