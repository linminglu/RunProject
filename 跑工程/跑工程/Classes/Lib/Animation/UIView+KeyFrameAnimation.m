//
//  UIView+KeyPathAnimation.m
//  EditStyle
//
//  Created by huangdaxia on 16/1/20.
//  Copyright © 2016年 xiaorizi. All rights reserved.
//

#import "UIView+KeyFrameAnimation.h"

@implementation UIView (KeyFrameAnimation)

#pragma mark 通用构建
- (CAKeyframeAnimation *)keyFrameAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.duration             = duration;
    return animation;
}

- (void)keepState:(CAKeyframeAnimation *)animation {
    animation.fillMode            = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
}

#pragma mark 关键帧动画
/**
 *  关键路径的移动动画
 *
 *  @param duration        动画持续时间
 *  @param pointValueArray 装有路径点的NSValue数组
 *  @param bKeepState      是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param delegate        代理对象 可以监听动画开始或结束
 */
- (void)addKeyFrameAnimationWithDurationTime:(CFTimeInterval)duration pointValueArray:(NSArray *)pointValueArray keepState:(BOOL)bKeepState delegate:(id)delegate {
    CAKeyframeAnimation *keyFrameAnimation = [self keyFrameAnimationWithKeyPath:@"position" duration:duration];
    keyFrameAnimation.values               = pointValueArray;
    keyFrameAnimation.timingFunction       = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    keyFrameAnimation.delegate             = delegate;
    if (bKeepState) {
        [self keepState:keyFrameAnimation];
    }
    
    [self.layer addAnimation:keyFrameAnimation forKey:@"keyFrameAnimation"];
}

/**
 *  根据所给定的路径进行移动动画
 *
 *  @param duration   动画持续时间
 *  @param path       rect转化为UIBezierPath对象进行动画路径
 *  @param bKeepState 是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param delegate   代理对象 可以监听动画开始或结束
 */
- (void)addPathAnimationWithDurationTime:(CFTimeInterval)duration path:(UIBezierPath *)path keepState:(BOOL)bKeepState delegate:(id)delegate {
    CAKeyframeAnimation *pathAnimation = [self keyFrameAnimationWithKeyPath:@"position" duration:duration];
    pathAnimation.path                 = path.CGPath;
    pathAnimation.delegate             = delegate;
    if (bKeepState) {
        [self keepState:pathAnimation];
    }
    
    [self.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
}

/**
 *  抖动动画
 *
 *  @param duration    动画持续时间
 *  @param numberArray 抖动的幅度数组 里面的类型为NSNumber
 *  @param bKeepState  是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param delegate    代理对象 可以监听动画开始或结束
 */
- (void)addShakeAnimationWithDurationTime:(CFTimeInterval)duration numberArray:(NSArray *)numberArray keepState:(BOOL)bKeepState delegate:(id)delegate {
    CAKeyframeAnimation *shakeAnimation = [self keyFrameAnimationWithKeyPath:@"transform.rotation" duration:duration];
    shakeAnimation.values               = numberArray;
    shakeAnimation.delegate             = delegate;
    if (bKeepState) {
        [self keepState:shakeAnimation];
    }
    
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}
@end
