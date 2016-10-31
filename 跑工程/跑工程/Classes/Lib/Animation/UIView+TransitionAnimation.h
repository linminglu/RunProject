//
//  UIView+TransitionAnimation.h
//  EditStyle
//
//  Created by huangdaxia on 16/1/20.
//  Copyright © 2016年 xiaorizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (TransitionAnimation)
/**
 *  其他动画
 *
 *  @param type     动画类型
 *  @param subType  动画方向
 *  @param duration 动画持续时间
 */
- (void)addTransitionAnimationWithType:(NSString *)type subType:(NSString *)subType durationTime:(CFTimeInterval)duration;

#pragma mark 公开的过渡动画
/**
 *  逐渐消失
 *
 *  @param duration 动画持续时间
 */
- (void)addFadeAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  逐渐消失
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addFadeAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *  逐渐移动覆盖
 *
 *  @param duration 动画持续时间
 */
- (void)addMoveInAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  逐渐移动覆盖
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addMoveInAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *  push
 *
 *  @param duration 动画持续时间
 */
- (void)addPushAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  push
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addPushAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *  Reveal
 *
 *  @param duration 动画持续时间
 */
- (void)addRevealAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  Reveal
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addRevealAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

#pragma mark 私有的过渡动画

#warning 如果使用下列动画 可能会造成审核不通过
/**
 *  立体翻滚效果
 *
 *  @param duration 动画持续时间
 */
- (void)addCubeAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  立体翻滚效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addCubeAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *  飞离的效果
 *
 *  @param duration 动画持续时间
 */
- (void)addSuckEffectAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  飞离的效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addSuckEffectAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *  翻转效果
 *
 *  @param duration 动画持续时间
 */
- (void)addOglFlipAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  翻转效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addOglFlipAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *
 *
 *  @param duration 动画持续时间
 */
- (void)addRippleEffectAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addRippleEffectAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *
 *
 *  @param duration 动画持续时间
 */
- (void)addPageCurlAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addPageCurlAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *
 *
 *  @param duration 动画持续时间
 */
- (void)addPageUnCurlAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addPageUnCurlAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *  相机打开的效果
 *
 *  @param duration 动画持续时间
 */
- (void)addCameraIrisHollowOpenAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  相机打开的效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addCameraIrisHollowOpenAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;

/**
 *  相机关闭的效果
 *
 *  @param duration 动画持续时间
 */
- (void)addCameraIrisHollowCloseAnimationWithDurationTime:(CFTimeInterval)duration;

/**
 *  相机关闭的效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addCameraIrisHollowCloseAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType;
@end
