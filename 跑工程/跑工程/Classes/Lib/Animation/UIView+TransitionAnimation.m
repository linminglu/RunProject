//
//  UIView+TransitionAnimation.m
//  EditStyle
//
//  Created by huangdaxia on 16/1/20.
//  Copyright © 2016年 xiaorizi. All rights reserved.
//

#import "UIView+TransitionAnimation.h"

@implementation UIView (TransitionAnimation)

- (void)addTransitionAnimationWithType:(NSString *)type subType:(NSString *)subType durationTime:(CFTimeInterval)duration {
    CATransition *animation = [CATransition animation];
    animation.type          = type;
    animation.subtype       = subType;
    animation.duration      = duration;
    [self.layer addAnimation:animation forKey:[NSString stringWithFormat:@"%@Animation",type]];
}

/*
 type:
 kCATransitionFade;
 kCATransitionMoveIn;
 kCATransitionPush;
 kCATransitionReveal;
 */

/*
 subType:
 kCATransitionFromRight;
 kCATransitionFromLeft;
 kCATransitionFromTop;
 kCATransitionFromBottom;
 */

#pragma mark 公开的过渡动画
/**
 *  逐渐消失
 *
 *  @param duration 动画持续时间
 */
- (void)addFadeAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addFadeAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  逐渐消失
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addFadeAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:kCATransitionFade subType:subType durationTime:duration];
}

/**
 *  逐渐移动覆盖
 *
 *  @param duration 动画持续时间
 */
- (void)addMoveInAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addMoveInAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  逐渐移动覆盖
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addMoveInAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:kCATransitionMoveIn subType:subType durationTime:duration];
}

/**
 *  push
 *
 *  @param duration 动画持续时间
 */
- (void)addPushAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addPushAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  push
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addPushAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:kCATransitionPush subType:subType durationTime:duration];
}

/**
 *  Reveal
 *
 *  @param duration 动画持续时间
 */
- (void)addRevealAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addRevealAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  Reveal
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addRevealAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:kCATransitionReveal subType:subType durationTime:duration];
}

#pragma mark 私有的过渡动画

#warning 如果使用下列动画 可能会造成审核不通过
/**
 *  立体翻滚效果
 *
 *  @param duration 动画持续时间
 */
- (void)addCubeAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addCubeAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  立体翻滚效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addCubeAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"cube" subType:subType durationTime:duration];
}

/**
 *  飞离的效果
 *
 *  @param duration 动画持续时间
 */
- (void)addSuckEffectAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addSuckEffectAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  飞离的效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addSuckEffectAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"suckEffect" subType:subType durationTime:duration];
}

/**
 *  翻转效果
 *
 *  @param duration 动画持续时间
 */
- (void)addOglFlipAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addOglFlipAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  翻转效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addOglFlipAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"oglFlip" subType:subType durationTime:duration];
}

/**
 *
 *
 *  @param duration 动画持续时间
 */
- (void)addRippleEffectAnimationWithDurationTime:(CFTimeInterval)duration {
    [self addRippleEffectAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addRippleEffectAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"rippleEffect" subType:subType durationTime:duration];
}

/**
 *
 *
 *  @param duration 动画持续时间
 */
- (void)addPageCurlAnimationWithDurationTime:(CFTimeInterval)duration {
      [self addPageCurlAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addPageCurlAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"pageCurl" subType:subType durationTime:duration];
}

/**
 *
 *
 *  @param duration 动画持续时间
 */
- (void)addPageUnCurlAnimationWithDurationTime:(CFTimeInterval)duration {
     [self addPageUnCurlAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addPageUnCurlAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"pageUnCurl" subType:subType durationTime:duration];
}

/**
 *  相机打开的效果
 *
 *  @param duration 动画持续时间
 */
- (void)addCameraIrisHollowOpenAnimationWithDurationTime:(CFTimeInterval)duration {
     [self addCameraIrisHollowOpenAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  相机打开的效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addCameraIrisHollowOpenAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"cameraIrisHollowOpen" subType:subType durationTime:duration];
}

/**
 *  相机关闭的效果
 *
 *  @param duration 动画持续时间
 */
- (void)addCameraIrisHollowCloseAnimationWithDurationTime:(CFTimeInterval)duration {
     [self addCameraIrisHollowCloseAnimationWithDurationTime:duration subType:kCATransitionFromRight];
}

/**
 *  相机关闭的效果
 *
 *  @param duration 动画持续时间
 *  @param subType  动画方向
 */
- (void)addCameraIrisHollowCloseAnimationWithDurationTime:(CFTimeInterval)duration subType:(NSString *)subType {
    [self addTransitionAnimationWithType:@"cameraIrisHollowClose" subType:subType durationTime:duration];
}
@end
