//
//  UIView+KeyPathAnimation.h
//  EditStyle
//
//  Created by huangdaxia on 16/1/20.
//  Copyright © 2016年 xiaorizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (KeyFrameAnimation)
/**
 *  关键路径的移动动画
 *
 *  @param duration        动画持续时间
 *  @param pointValueArray 装有路径点的NSValue数组
 *  @param bKeepState      是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param delegate        代理对象 可以监听动画开始或结束
 */
- (void)addKeyFrameAnimationWithDurationTime:(CFTimeInterval)duration pointValueArray:(NSArray *)pointValueArray keepState:(BOOL)bKeepState delegate:(id)delegate;

/**
 *  根据所给定的路径进行移动动画
 *
 *  @param duration   动画持续时间
 *  @param path       rect转化为UIBezierPath对象进行动画路径
 *  @param bKeepState 是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param delegate   代理对象 可以监听动画开始或结束
 */
- (void)addPathAnimationWithDurationTime:(CFTimeInterval)duration path:(UIBezierPath *)path keepState:(BOOL)bKeepState delegate:(id)delegate;

/**
 *  抖动动画
 *
 *  @param duration    动画持续时间
 *  @param numberArray 抖动的幅度数组 里面的类型为NSNumber
 *  @param bKeepState  是否让view保留最终状态 如果为NO view会执行完动画后回到起始的样子
 *  @param delegate    代理对象 可以监听动画开始或结束
 */
- (void)addShakeAnimationWithDurationTime:(CFTimeInterval)duration numberArray:(NSArray *)numberArray keepState:(BOOL)bKeepState delegate:(id)delegate;
@end
