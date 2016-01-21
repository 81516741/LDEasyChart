//
//  ViewController.m
//  小图表
//
//  Created by ld on 16/1/20.
//  Copyright © 2016年 kingpoint. All rights reserved.


#import "ViewController.h"
#import "LDEasyChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建表格
    LDEasyChart * chart = [LDEasyChart easyChart];
    //设置点的间距
    chart.gapX = 80;
    //设置表的位置和大小
    chart.frame = CGRectMake(10, 100, 320, 400);
    //添加
    [self.view addSubview:chart];
    
    //传递数据（这里是主要的，values和times须一一对应）
    NSArray * values = @[@"1",@"8",@"5",@"2",@"5"];
    NSArray * times = @[@"12/01",@"12/02",@"12/03",@"12/04",@"12/05"];
    [chart drawChartWithValues:values times:times];
    [chart setTitleX:@"天王" titleY:@"地虎" titleMain:@"小鸡炖蘑菇"];
    //回传点击了那个位置和这个位置对应的value
    chart.dataBlock = ^(NSInteger index,NSInteger value){
        NSLog(@"%zd---%zd",index,value);
    };
}


@end
