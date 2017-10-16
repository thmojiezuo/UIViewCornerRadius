//
//  UIView+Expand.h
//  keyikeyi
//
//  Created by keyi on 15/8/29.
//  Copyright (c) 2015年 tenghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 设置视图圆角
 */
- (void)k_cornerWithRadius:(CGFloat)radius;
/**
 设置视图上方为圆角
 */
- (void)k_topCornerWithRadius:(CGFloat)radius;
/**
 设置视图下方为圆角
 */
- (void)k_bottomCornerWithRadius:(CGFloat)radius;
/**
 设置视图圆角，并添加边缘线颜色，线条粗细
 */
- (void)k_cornerWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
/**
 移除视图圆角
 */
- (void)removeCorner;
/**
 判断视图是否有圆角设置
 */
- (BOOL)hasCornered;


/**
 设置视图抖动几下
 */
-(void)k_setViewJitter;

/**
 视图的centerX
 */
@property (nonatomic) CGFloat centerX;
/**
 视图的centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 视图的宽
 */
- (CGFloat)width;

/**
 视图的高
 */
- (CGFloat)height;

/**
 视图的y
 */
- (CGFloat)top;

/**
 视图的y + 视图的高
 */
- (CGFloat)bottom;

/**
 视图的x
 */
- (CGFloat)left;

/**
 视图的x + 视图的宽
 */
- (CGFloat)right;

/**
 重新设置视图的宽
 */
- (void)setWidth:(CGFloat)width;

/**
 重新设置视图的高
 */
- (void)setHeight:(CGFloat)height;

/**
 重新设置视图的x
 */
- (void)setLeft:(CGFloat)left;

/**
 重新设置视图的y
 */
- (void)setTop:(CGFloat)top;

/**
 重新设置视图的Origin
 */
- (void)setOrigin:(CGPoint)origin;

/**
 重新设置视图的size
 */
- (void)setSize:(CGSize)size;


@end
