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

//进度(菊花)提示
+ (MBProgressHUD *)showProgress:(NSString *)msg toView:(UIView *)view;

//显示
+ (void)show:(NSString *)msg toView:(UIView *)view mode:(ProgressMode)myMode;

//显示提示（N秒后消失）
+ (void)showMessage:(NSString *)msg toView:(UIView *)view afterDelayTime:(NSInteger)delay;

//显示进度(转圈)
+ (MBProgressHUD *)showProgressCircle:(NSString *)msg toView:(UIView *)view;

//隐藏
+ (void)hide;

@end
