//
//  UIView+BaseAnimation.h
//  EditStyle
//
//  Created by huangdaxia on 16/1/20.
//  Copyright © 2016年 xiaorizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (BaseAnimation)
/**
 *  位移动画 调用这个方法 会让view从一个地方 位移到给定的点的地方
 *
 *  @param duration         动画持续时间
 *  @param toPoint          结束的位置
 *  @param bKeepState       是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param bChangeViewFrame 是否改变图片的最重位置 如果为NO view的属性值还是动画执行前的初始值，并没有真正的改变
 */
- (void)addPositionAnimationWithDurationTime:(CFTimeInterval)duration endPoint:(CGPoint)toPoint keepState:(BOOL)bKeepState changeViewFrame:(BOOL)bChangeViewFrame;

/**
 *  透明度渐变动画
 *
 *  @param duration   动画持续时间
 *  @param startValue 开始的透明值
 *  @param endValue   结束的透明值
 *  @param bKeepState 是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addOpacityAnimationWithDurationTime:(CFTimeInterval)duration startValue:(CGFloat)startValue endValue:(CGFloat)endValue keepState:(BOOL)bKeepState;

/**
 *  缩放动画
 *
 *  @param duration   动画持续时间
 *  @param scaleValue 需要缩放的倍数
 *  @param bKeepState 是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addScaleAnimationWithDurationTime:(CFTimeInterval)duration scaleValue:(CGFloat)scaleValue keepState:(BOOL)bKeepState;

/**
 *  绕z轴旋转动画
 *
 *  @param duration    动画持续时间
 *  @param rotateValue 旋转大小
 *  @param repeatCount 重复次数
 *  @param bKeepState  是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addRotateAnimationWithDurationTime:(CFTimeInterval)duration rotateValue:(CGFloat)rotateValue repeatCount:(CGFloat)repeatCount keepState:(BOOL)bKeepState;

/**
 *  背景色渐变动画
 *
 *  @param duration   动画持续时间
 *  @param color      需要渐变的颜色
 *  @param bKeepState 是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addBackgroundColorAnimationWithDurationTime:(CFTimeInterval)duration color:(UIColor *)color keepState:(BOOL)bKeepState;
@end
