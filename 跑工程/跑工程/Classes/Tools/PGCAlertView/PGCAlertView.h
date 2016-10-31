//
//  PGCAlertView.h
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCAlertView;

@protocol PGCAlertViewDelegate <NSObject>

@optional

/**
 确定按钮代理方法

 @param alertView
 @param confirm
 */
- (void)alertView:(PGCAlertView *)alertView confirm:(UIButton *)confirm;

/**
 呼叫联系人代理方法

 @param alertView
 @param phone
 */
- (void)alertView:(PGCAlertView *)alertView phone:(UIButton *)phone;

/**
 添加联系人代理方法

 @param alertView
 @param addContact
 */
- (void)alertView:(PGCAlertView *)alertView addContact:(UIButton *)addContact;

@end


@interface PGCAlertView : UIView

@property (weak, nonatomic) id <PGCAlertViewDelegate> delegate;

/**
 初始化判断alert view

 @param title
 @return
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 初始化按钮alert view

 @param model
 @return
 */
- (instancetype)initWithModel:(id)model;

/**
 显示alert view
 */
- (void)showAlertView;

@end
