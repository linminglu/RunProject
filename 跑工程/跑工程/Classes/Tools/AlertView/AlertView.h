//
//  AlertView.h
//  GraduationProject
//
//  Created by Chrissy on 16/3/30.
//  Copyright © 2016年 Liushengtao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击样式
 */
typedef NS_ENUM(NSInteger, MyWindowClick) {
    MyWindowClickForOK = 0, // 点击确定按钮
    MyWindowClickForCancel  // 点击取消按钮
};

/**
 *  提示框显示样式
 */
typedef NS_ENUM(NSInteger, AlertViewStyle) {
    AlertViewStyleDefalut = 0,  //默认样式 成功
    AlertViewStyleSuccess,      //成功
    AlertViewStyleFail,         //失败
    AlertViewStyleWaring        //警告
};

typedef void (^CallBack)(MyWindowClick buttonIndex);

@interface AlertView : UIWindow

@property (nonatomic, copy) CallBack clickBlock ;//按钮点击事件的回调

+ (instancetype)shared;

/**
 *  创建AlertView并展示
 *
 *  @param style    绘制的图片样式
 *  @param title    警示标题
 *  @param detail   警示内容
 *  @param canle    取消按钮标题
 *  @param ok       确定按钮标题
 *  @param callBack 按钮点击时间回调
 *
 *  @return 返回AlertView
 */
+ (instancetype)showAlertViewWithStyle:(AlertViewStyle)style title:(NSString *)title detail:(NSString *)detail cancelButtonTitle:(NSString *)cancel okButtonTitle:(NSString *)ok callBlock:(CallBack)callBack;

/**
 *  默认样式创建AlertView
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)title detail:(NSString *)detail cancelButtonTitle:(NSString *)cancel okButtonTitle:(NSString *)ok callBlock:(CallBack)callBack;

@end
