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
 我知道了按钮代理方法
 */
- (void)hintAlertView:(PGCHintAlertView *)hintAlertView known:(UIButton *)known;
/**
 确定按钮代理方法
 */
- (void)hintAlertView:(PGCHintAlertView *)hintAlertView confirm:(UIButton *)confirm;

@end


@interface PGCHintAlertView : UIView

@property (weak, nonatomic) id <PGCHintAlertViewDelegate> delegate;
/**
 初始化判断alert view
 */
- (instancetype)initWithTitle:(NSString *)title;
/**
 初始化判断alert view
 */
- (instancetype)initWithContent:(NSString *)content;
/**
 显示alert view 
 */
- (void)showHintAlertView;

@end
