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

#pragma mark -
#pragma mark - UIAlertController
/**
 *  1.0s后消失的弹出框提示
 *
 *  @param target 调用UIAlertController的对象
 *  @param title  提示语句
 */
+ (void)showAlertWithTarget:(id)target
                      title:(NSString *)title;

/**
 *  1.0s后消失的弹出框提示
 *
 *  @param title 提示语句
 *  @param block block回调
 */
+ (void)showAlertWithTitle:(NSString *)title
                     block:(void(^)(void))block;
/**
 *  一个按钮弹出框
 *
 *  @param target     调用UIAlertController的对象
 *  @param title      弹出框标题
 *  @param message    提示语句
 *  @param otherTitle 弹出框按钮标题
 *  @param handler    弹出框按钮的事件
 */
+ (void)showAlertWithTarget:(id)target
                      title:(NSString *)title
                    message:(NSString *)message
            actionWithTitle:(NSString *)otherTitle
                    handler:(void (^)(UIAlertAction *action))handler;
/**
 两个按钮弹出框

 @param target
 @param title
 @param message
 @param actionTitle
 @param otherActionTitle
 @param handler
 */
+ (void)showAlertWithTarget:(id)target
                      title:(NSString *)title
                    message:(NSString *)message
                actionTitle:(NSString *)actionTitle
           otherActionTitle:(NSString *)otherActionTitle
                    handler:(void (^)(UIAlertAction *action))handler
               otherHandler:(void (^)(UIAlertAction *action))otherHandler;



#pragma mark -
#pragma mark - MBProgressHUD

@property (strong, nonatomic) MBProgressHUD *hud;

+ (instancetype)shareinstance;

/**
 进度(菊花)提示的MBProgressHUD

 @param view
 @param label
 @return
 */
+ (MBProgressHUD *)showProgressHUD:(UIView *)view label:(NSString *)label;



//显示
+(void)show:(NSString *)msg toView:(UIView *)view mode:(ProgressMode)myMode;

//隐藏
+(void)hide;

//显示提示（1.5秒后消失）
+(void)showMessage:(NSString *)msg toView:(UIView *)view;

//显示提示（N秒后消失）
+(void)showMessage:(NSString *)msg toView:(UIView *)view afterDelayTime:(NSInteger)delay;

//显示进度(转圈)
+(MBProgressHUD *)showProgressCircle:(NSString *)msg toView:(UIView *)view;

//显示进度(菊花)
+(void)showProgress:(NSString *)msg toView:(UIView *)view;

//显示成功提示
+(void)showSuccess:(NSString *)msg toView:(UIView *)view;

//在最上层显示
+(void)showMsgWithoutView:(NSString *)msg;


@end
