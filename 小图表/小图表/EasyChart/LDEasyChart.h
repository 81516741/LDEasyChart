//
//  LDEasyChart.h
//  实用简单的图表
//
//  Created by ld on 16/1/20.
//  Copyright © 2016年 kingpoint. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Operation)(NSInteger,NSInteger);

@interface LDEasyChart : UIView
/**
 图表需要的数据
 */
-(void)drawChartWithValues:(NSArray *)values times:(NSArray *)times;
/**
 *  设置x，y的title和顶部title
 */
-(void)setTitleX:(NSString *)titleX titleY:(NSString *)titleY titleMain:(NSString *)titleMain;
/**
 x轴方向点的间距
 */
@property(nonatomic, assign) NSInteger gapX;
/**
 点击点后传值
 */
@property(nonatomic, copy) Operation dataBlock;
/**
 *  快速创建表格
 */
+(instancetype)easyChart;

@end
