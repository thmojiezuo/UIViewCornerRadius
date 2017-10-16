//
//  UIView+Expand.m
//  keyikeyi
//
//  Created by keyi on 15/8/29.
//  Copyright (c) 2015年 tenghu. All rights reserved.
//

#import "UIView+Extension.h"

static NSString *KCornerLayerName = @"KCornerShapeLayer";

typedef NS_OPTIONS(NSUInteger, KRoundCorner) {
    KRoundCornerTop = (UIRectCornerTopLeft | UIRectCornerTopRight),
    KRoundCornerBottom = (UIRectCornerBottomLeft | UIRectCornerBottomRight),
    KRoundCornerAll = UIRectCornerAllCorners
};

@implementation UIView (Extension)

- (void)k_roundingCorner:(KRoundCorner)roundCorner radius:(CGFloat)radius{
    
    [self removeCorner];
    CGRect cornerBounds =  self.bounds;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.name = KCornerLayerName;
    UIRectCorner sysCorner = (UIRectCorner)roundCorner;
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:cornerBounds byRoundingCorners:sysCorner cornerRadii:CGSizeMake(radius, radius)];

    shapeLayer.path = cornerPath.CGPath;
    /*
     字面意思是“奇偶”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点的数量。如果结果是奇数则认为点在内部，是偶数则认为点在外部
     */
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
 
    if ([self isKindOfClass:[UILabel class]]) {
        //UILabel 机制不一样的  UILabel 设置 text 为 中文 也会造成图层混合 (iOS8 之后UILabel的layer层改成了 _UILabelLayer 具体可阅读 http://www.jianshu.com/p/db6602413fa3 )
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self.layer setMask:shapeLayer];
        });
        return;
    }
    [self.layer setMask:shapeLayer];
    
}
- (void)k_roundingCorner:(KRoundCorner)roundCorner radius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    [self removeCorner];
    CGRect cornerBounds =  self.bounds;
    CGFloat width = CGRectGetWidth(cornerBounds);
    CGFloat height = CGRectGetHeight(cornerBounds);
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.name = KCornerLayerName;
    UIRectCorner sysCorner = (UIRectCorner)roundCorner;
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:cornerBounds byRoundingCorners:sysCorner cornerRadii:CGSizeMake(radius, radius)];
    [path  appendPath:cornerPath];
    //[path setUsesEvenOddFillRule:YES];
    
    shapeLayer.path = path.CGPath;
    /*
     字面意思是“奇偶”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点的数量。如果结果是奇数则认为点在内部，是偶数则认为点在外部
     */
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path = cornerPath.CGPath;
    self.layer.mask = borderLayer;
    
    //CGPathApply
    CGFloat cornerPathLength = lengthOfCGPath(roundCorner,radius,cornerBounds.size);
    CGFloat totolPathLength = 2*(CGRectGetHeight(cornerBounds)+CGRectGetWidth(cornerBounds))+cornerPathLength;
    shapeLayer.strokeStart = (totolPathLength-cornerPathLength)/totolPathLength;
    shapeLayer.strokeEnd = 1.0;
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.strokeColor = borderColor.CGColor; //线的颜色
    

    if ([self isKindOfClass:[UILabel class]]) {
        //UILabel 机制不一样的  UILabel 设置 text 为 中文 也会造成图层混合 (iOS8 之后UILabel的layer层改成了 _UILabelLayer 具体可阅读 http://www.jianshu.com/p/db6602413fa3 )
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.layer addSublayer:shapeLayer];
        });
        return;
    }
    
   
    
    [self.layer addSublayer:shapeLayer];
    
}

/**
 关于 CGPath 的 length 的计算请参看 http://www.mlsite.net/blog/?p=1312 与 http://stackoverflow.com/questions/6515158/get-info-about-a-cgpath-uibezierpath 在这里简单的计算就能满足要求因此不做过多讨论
 */
float lengthOfCGPath (KRoundCorner roundingCorner,CGFloat radius,CGSize size) {
    CGFloat totolLength = 0.0;
    switch (roundingCorner) {
        case KRoundCornerTop:
        case KRoundCornerBottom:
            totolLength = 2*(size.width + size.height) - 4*radius + (M_PI * radius);
            break;
        case KRoundCornerAll:
            totolLength = 2*(size.width + size.height) - 8*radius + (M_PI * radius)*2;
        default:
            break;
    }
    return totolLength;
}

#pragma mark - 设置视图圆角
- (void)k_cornerWithRadius:(CGFloat)radius{
     [self k_roundingCorner:KRoundCornerAll radius:radius ];
}

#pragma mark 设置视图上方为圆角
- (void)k_topCornerWithRadius:(CGFloat)radius{
     [self k_roundingCorner:KRoundCornerTop radius:radius ];
}

#pragma mark  设置视图下方为圆角
- (void)k_bottomCornerWithRadius:(CGFloat)radius{
    [self k_roundingCorner:KRoundCornerBottom radius:radius ];
}

#pragma mark 设置视图圆角，并添加边缘线颜色，线条粗细
- (void)k_cornerWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    [self k_roundingCorner:KRoundCornerAll radius:radius borderColor:borderColor borderWidth:borderWidth];
}
#pragma mark 移除视图圆角
-(void)removeCorner {
    if ([self hasCornered]) {
        CALayer *layer = nil;
        for (CALayer *subLayer in self.layer.sublayers) {
            if ([subLayer.name isEqualToString:KCornerLayerName]) {
                layer = subLayer;
            }
        }
        [layer removeFromSuperlayer];
    }
}
#pragma mark 判断视图是否有圆角设置
- (BOOL)hasCornered {
    for (CALayer *subLayer in self.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAShapeLayer class]] && [subLayer.name isEqualToString:KCornerLayerName]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - view 抖动
-(void)k_setViewJitter {
    // 获取到当前的View
    CALayer *viewLayer = self.layer;
    
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 5, position.y);
    
    CGPoint y = CGPointMake(position.x - 5, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    [animation setAutoreverses:YES];
    
    // 设置时间
    [animation setDuration:.05];
    
    // 设置次数
    [animation setRepeatCount:2];
    
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
    
}
#pragma mark - 一些属性方法

//centerX
- (CGFloat)centerX {
    
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint newCenter = self.center;
    newCenter.x       = centerX;
    self.center       = newCenter;
}
//centerY
- (CGFloat)centerY {
    
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint newCenter = self.center;
    newCenter.y       = centerY;
    self.center       = newCenter;
}

//设置宽
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

//设置高
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

//设置x
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

//设置y
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

//设置Origin
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

//设置size
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
//宽
- (CGFloat)width {
    return self.frame.size.width;
}

//高
- (CGFloat)height {
    return self.frame.size.height;
}

//上
- (CGFloat)top {
    return self.frame.origin.y;
}

//下
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

//左
- (CGFloat)left {
    return self.frame.origin.x;
}

//右
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

@end
