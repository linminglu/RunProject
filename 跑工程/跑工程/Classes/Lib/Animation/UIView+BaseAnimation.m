//
//  UIView+BaseAnimation.m
//  EditStyle
//
//  Created by huangdaxia on 16/1/20.
//  Copyright © 2016年 xiaorizi. All rights reserved.
//

#import "UIView+BaseAnimation.h"

@implementation UIView (BaseAnimation)

#pragma mark 通用构建
- (CABasicAnimation *)baseAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration          = duration;
    return animation;
}

- (void)keepState:(CABasicAnimation *)animation {
    animation.fillMode      = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
}

- (void)changeViewFrame:(UIView *)view endPoint:(CGPoint)toPoint {
    CGRect rect   = view.frame;
    rect.origin.x = toPoint.x - rect.size.width / 2;
    rect.origin.y = toPoint.y - rect.size.height / 2;
    view.frame    = rect;
}

#pragma mark 基本动画
/**
 *  位移动画 调用这个方法 会让图片从一个地方 位移到给定的点的地方
 *
 *  @param duration         动画持续时间
 *  @param toPoint          结束的位置
 *  @param bKeepState       是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param bChangeViewFrame 是否改变图片的最重位置 如果为NO view的属性值还是动画执行前的初始值，并没有真正的改变
 */
- (void)addPositionAnimationWithDurationTime:(CFTimeInterval)duration endPoint:(CGPoint)toPoint keepState:(BOOL)bKeepState changeViewFrame:(BOOL)bChangeViewFrame {
    CABasicAnimation *positionAnimation = [self baseAnimationWithKeyPath:@"position" duration:duration];
    positionAnimation.fromValue         = [NSValue valueWithCGPoint:self.center];
    positionAnimation.toValue           = [NSValue valueWithCGPoint:toPoint];
    if (bKeepState) {
        [self keepState:positionAnimation];
    }
    if (bChangeViewFrame) {
        [self changeViewFrame:self endPoint:toPoint];
    }
    
    [self.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
}

/**
 *  透明度渐变动画
 *
 *  @param duration   动画持续时间
 *  @param startValue 开始的透明值
 *  @param endValue   结束的透明值
 *  @param bKeepState 是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addOpacityAnimationWithDurationTime:(CFTimeInterval)duration startValue:(CGFloat)startValue endValue:(CGFloat)endValue keepState:(BOOL)bKeepState {
    CABasicAnimation *opacityAnimation = [self baseAnimationWithKeyPath:@"opacity" duration:duration];
    opacityAnimation.fromValue         = [NSNumber numberWithFloat:startValue];
    opacityAnimation.toValue           = [NSNumber numberWithFloat:endValue];
    if (bKeepState) {
        [self keepState:opacityAnimation];
    }
    
    [self.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

/**
 *  缩放动画
 *
 *  @param duration   动画持续时间
 *  @param scaleValue 需要缩放的倍数
 *  @param bKeepState 是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addScaleAnimationWithDurationTime:(CFTimeInterval)duration scaleValue:(CGFloat)scaleValue keepState:(BOOL)bKeepState {
    CABasicAnimation *scaleAnimation = [self baseAnimationWithKeyPath:@"transform.scale" duration:duration];
    scaleAnimation.toValue           = [NSNumber numberWithFloat:scaleValue];
    if (bKeepState) {
        [self keepState:scaleAnimation];
    }
    
    [self.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

/**
 *  绕z轴旋转动画
 *
 *  @param duration    动画持续时间
 *  @param rotateValue 旋转大小
 *  @param repeatCount 重复次数
 *  @param bKeepState  是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addRotateAnimationWithDurationTime:(CFTimeInterval)duration rotateValue:(CGFloat)rotateValue repeatCount:(CGFloat)repeatCount keepState:(BOOL)bKeepState {
    CABasicAnimation *rotateAnimation = [self baseAnimationWithKeyPath:@"transform.rotation.z" duration:duration];
    rotateAnimation.toValue           = [NSNumber numberWithFloat:rotateValue];
    rotateAnimation.repeatCount       = repeatCount;
    if (bKeepState) {
        [self keepState:rotateAnimation];
    }
    
    [self.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

/**
 *  背景色渐变动画
 *
 *  @param duration   动画持续时间
 *  @param color      需要渐变的颜色
 *  @param bKeepState 是否保持最终状态 如果为NO view会执行完动画后回到起始的样子
 */
- (void)addBackgroundColorAnimationWithDurationTime:(CFTimeInterval)duration color:(UIColor *)color keepState:(BOOL)bKeepState {
    CABasicAnimation *backgroundAnimation = [self baseAnimationWithKeyPath:@"backgroundColor" duration:duration];
    backgroundAnimation.toValue           = (id)color.CGColor;
    if (bKeepState) {
        [self keepState:backgroundAnimation];
    }
    
    [self.layer addAnimation:backgroundAnimation forKey:@"backgroundAnimation"];
}
@end
