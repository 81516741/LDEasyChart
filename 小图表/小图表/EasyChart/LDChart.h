//
//  LDChart.h
//  实用简单的图表
//
//  Created by ld on 16/1/20.
//  Copyright © 2016年 kingpoint. All rights reserved.


#import <UIKit/UIKit.h>

@class LDChart;

@protocol LDChartDataSource <NSObject>

@required
/**
 点/数字 的个数
 */
-(NSInteger)numberForChart:(LDChart *)chart;
/**
 对应点的value值
 */
-(NSInteger)chart:(LDChart *)chart valueAtIndex:(NSInteger)index;
@optional
/**
 对应点x轴显示值
 */
-(NSString *)chart:(LDChart *)chart timeAtIndex:(NSInteger)index;
/**
 *  间距
 */
-(NSInteger)gap;
@end

@protocol LDChartDelegate <NSObject>

@optional
/**
点的点击事件
 */
-(void)chart:(LDChart *)view didClickPointAtIndex:(NSInteger)index value:(NSInteger)value;
@end

@interface LDChart : UIView
@property(nonatomic,assign)id<LDChartDataSource> dataSource;
@property(assign, nonatomic)id<LDChartDelegate> delegate;
/**
 *  重绘
 */
-(void)reDraw;
@end
