//
//  PGCProgressHUD.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSUInteger, ProgressMode) {
    ProgressModeOnlyText,//文字
    ProgressModeLoading,//加载菊花
    ProgressModeCircleLoading,//加载圆形
    ProgressModeCustomAnimation,//自定义加载动画（序列帧实现）
    ProgressModeSuccess,//成功
};


@interface PGCProgressHUD : NSObject

@property (strong, nonatomic) MBProgressHUD *hud;

+(instancetype)shareinstance;


+ (void)showProgressHUDWithTitle:(NSString *)title;
+ (void)showProgressHUDWith:(UIView *)view
                      title:(NSString *)title;
+ (void)showProgressHUDWith:(UIView *)view
                      title:(NSString *)title
                      block:(void(^)(void))block;

+ (MBProgressHUD *)showProgressHUD:(UIView *)view label:(NSString *)label;

#pragma mark - UIAlertController
+ (void)showAlertWithTitle:(NSString *)title;
+ (void)showAlertWithTitle:(NSString *)title
                     block:(void(^)(void))block;
+ (void)showAlertWithTarget:(id)target title:(NSString *)title
                    message:(NSString *)message
            actionWithTitle:(NSString *)otherTitle
                    handler:(void (^)(void))handler;

//显示
+(void)show:(NSString *)msg inView:(UIView *)view mode:(ProgressMode)myMode;

//隐藏
+(void)hide;

//显示提示（1秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view;

//显示提示（N秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;

//显示进度(转圈)
+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view;

//显示进度(菊花)
+(void)showProgress:(NSString *)msg inView:(UIView *)view;

//显示成功提示
+(void)showSuccess:(NSString *)msg inView:(UIView *)view;

//在最上层显示
+(void)showMsgWithoutView:(NSString *)msg;

//显示自定义动画(自定义动画序列帧  找UI做就可以了)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view;
@end
