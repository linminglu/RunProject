//
//  PGCPayView.h
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCPayView;

@protocol PGCPayViewDelegate <NSObject>

@optional

/**
 微信代理方法

 @param payView
 @param weChat
 */
- (void)payView:(PGCPayView *)payView weChat:(UIButton *)weChat;


/**
 支付宝代理方法

 @param payView
 @param alipay
 */
- (void)payView:(PGCPayView *)payView alipay:(UIButton *)alipay;

@end

@interface PGCPayView : UIView

@property (weak, nonatomic) id <PGCPayViewDelegate> delegate;


/**
 初始化支付成功提示框

 @return
 */
- (instancetype)initWithSuccessPay;

/**
 显示选择支付视图
 */
- (void)showPayView;

/**
 显示支付成功视图
 */
- (void)showPayViewWithGCD;

@end
