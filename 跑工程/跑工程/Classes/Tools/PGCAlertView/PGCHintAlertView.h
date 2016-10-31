//
//  PGCHintAlertView.h
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCHintAlertView;

@protocol PGCHintAlertViewDelegate <NSObject>

@optional

/**
 确定按钮代理方法

 @param hintAlertView
 @param confirm
 */
- (void)hintAlertView:(PGCHintAlertView *)hintAlertView confirm:(UIButton *)confirm;

@end


@interface PGCHintAlertView : UIView

@property (weak, nonatomic) id <PGCHintAlertViewDelegate> delegate;

/**
 初始化判断alert view

 @param title
 @return
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 初始化判断alert view

 @param content
 @return
 */
- (instancetype)initWithContent:(NSString *)content;

/**
 显示alert view 
 */
- (void)showHintAlertView;

@end
