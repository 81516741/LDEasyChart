//
//  LDChart.h
//  实用简单的图表
//
//  Created by ld on 16/1/20.
//  Copyright © 2016年 kingpoint. All rights reserved.

#import "LDChart.h"
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

CGFloat margin=14.f;
CGFloat radius=3.0f;//中间小点的半径
CGFloat radiusPlus = 15.0f;//点击的有效半径
@interface LDChart ()

@property(nonatomic,assign)CGFloat avgHeight;
@property(nonatomic,assign)NSInteger maxValue;
@property(nonatomic,assign)NSInteger count;
@property (nonatomic, assign) CGPoint selectedPoint;
@property (nonatomic, assign ,getter=isDrawVerticalLine) BOOL drawVerticalLine;
@end
@implementation LDChart

//从nib加载
-(void)awakeFromNib{
    self.backgroundColor= [UIColor clearColor];
    _maxValue=1;
    self.drawVerticalLine = NO;
}
//自己创建
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _maxValue=1;
        self.drawVerticalLine = NO;
    }
    return self;
}
//返回点集合中最大的value值
-(NSInteger)maxValue
{
    NSInteger temp = 0;
    for (int i=0; i<self.count; i++) {
        NSInteger value= [_dataSource chart:self valueAtIndex:i];
        temp = temp > value? temp:value;
        _maxValue = temp;
    }
    return _maxValue;
}
//返回点集合点的总数
-(NSInteger)count
{
    return [_dataSource numberForChart:self];
}
//用最大的view的高度 除以最大的value 将y轴分成value份个单位
-(CGFloat)avgHeight
{
    CGFloat height=self.frame.size.height - 10;
    _avgHeight=(height-4*margin)/self.maxValue;
    return _avgHeight;
}
//绘制线条
-(void)drawRect:(CGRect)rect
{
    //走势线
    [self drawLine];
    //画点
    [self drawPoint];
    //x轴和点上画文字
    if (self.drawVerticalLine) {
        [self drawDashLine];
    }
}
//走势线
-(void)drawLine{
    UIBezierPath *path=[UIBezierPath bezierPath];
    for (int i=0; i<self.count; i++) {
        NSInteger value= [_dataSource chart:self valueAtIndex:i];
        CGPoint point=[self pointWithValue:value index:i];
        if (i==0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
    }
    path.lineWidth = 3;
    [RGB(88, 103, 215) set];
    [path stroke];
}

//画点和日期
-(void)drawPoint{
    for (int i=0; i<self.count; i++) {
  
        NSInteger value= [_dataSource chart:self valueAtIndex:i];
        NSString * valueStr = [NSString stringWithFormat:@"%zd",value];
        CGPoint point=[self pointWithValue:value index:i];
        //画点
        UIBezierPath *drawPointBoarder=[UIBezierPath bezierPath];
        [drawPointBoarder addArcWithCenter:point radius:radiusPlus * 0.4 startAngle:M_PI*0 endAngle:M_PI*2 clockwise:YES];
        [RGB(223, 119, 120) set];
        [drawPointBoarder fill];
        
        UIBezierPath *drawPoint=[UIBezierPath bezierPath];
        [drawPoint addArcWithCenter:point radius:radius startAngle:M_PI*0 endAngle:M_PI*2 clockwise:YES];
        [RGB(195, 24, 43) set];
        [drawPoint fill];
        
        //画日期文字
        NSString * dateString = [_dataSource chart:self timeAtIndex:i];
        NSDictionary * timeAtt = @{
                                   NSFontAttributeName:[UIFont systemFontOfSize:14]
                                   };
        [dateString drawAtPoint:CGPointMake(point.x - 20, self.bounds.size.height- 25) withAttributes:timeAtt];
       
        //画点上的提示文字
        UIBezierPath * bubble = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - 17, point.y - 25, 34, 16) cornerRadius:5];
        UIBezierPath * triAngle = [UIBezierPath bezierPath];
        [triAngle moveToPoint:CGPointMake(point.x, point.y - 5)];
        [triAngle addLineToPoint:CGPointMake(point.x - 10, point.y - 20)];
        [triAngle addLineToPoint:CGPointMake(point.x + 10, point.y - 20)];
        [RGB(223, 120, 120) set];
        [bubble fill];
        [triAngle fill];
        [[UIColor whiteColor]set];
        NSDictionary * valueAtt = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:13]
                               };
        if (value < 10 && value  > 0) {
            [valueStr drawAtPoint:CGPointMake(point.x - 3.0, point.y -25) withAttributes:valueAtt];
        }else if (value < 100 && value > 9){
            [valueStr drawAtPoint:CGPointMake(point.x - 7.0, point.y -25)  withAttributes:valueAtt];
        }else if (value < 1000 && value > 99){
            [valueStr drawAtPoint:CGPointMake(point.x - 12.0, point.y -25) withAttributes:valueAtt];
        }else if(value > 999 && value < 10000){
            CGFloat newValue = ((int)(value * 0.01))/10.0;
            NSString * newValueStr = [NSString stringWithFormat:@"%.1fk",newValue];
            [newValueStr drawAtPoint:CGPointMake(point.x - 13.0, point.y -25)  withAttributes:valueAtt];
        }else if(value > 9999&& value < 99999){
            CGFloat newValue = ((int)(value * 0.001))/10.0;
            NSString * newValueStr = [NSString stringWithFormat:@"%.1fw",newValue];
            [newValueStr drawAtPoint:CGPointMake(point.x - 13.0, point.y -25) withAttributes:valueAtt];
        }else if(value > 99999){
            [@"10w+" drawAtPoint:CGPointMake(point.x - 15.0, point.y -25) withAttributes:valueAtt];
        }
    }
}
//画虚线
-(void)drawDashLine{
    CGPoint point = [self pointWithValue:_selectedPoint.y index:_selectedPoint.x];
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, RGB(223, 120, 120).CGColor);
    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context,point.x, 10.0);
    CGContextAddLineToPoint(context,point.x,self.bounds.size.height - 25);
    CGContextStrokePath(context);
    self.drawVerticalLine = NO;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    for (NSInteger i=0; i<self.count; i++) {
        NSInteger value= [_dataSource chart:self valueAtIndex:i];
        CGPoint point=[self pointWithValue:value index:i];
        if (CGRectContainsPoint(CGRectMake(point.x-radiusPlus, point.y-radiusPlus, radiusPlus*2, radiusPlus*2), [touch locationInView:self])) {
            if (_delegate && [_delegate respondsToSelector:@selector(chart:didClickPointAtIndex:value:)]) {
                [_delegate chart:self didClickPointAtIndex:i value:value];
            }
            self.drawVerticalLine = YES;
            self.selectedPoint = CGPointMake(i, value);
            [self reDraw];
        }
    }

}

//根据valu和index获取点的坐标
-(CGPoint)pointWithValue:(NSInteger)value index:(NSInteger)index
{
    CGFloat height=self.frame.size.height;
    return  CGPointMake([self gap]*index + 40, height-value*self.avgHeight - 20);
}
-(NSInteger)gap
{
    return [self.dataSource gap];
}
//重绘
-(void)reDraw{
    [self setNeedsDisplay];
}

@end
