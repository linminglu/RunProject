//
//  PGCAppDelegate+AppService.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAppDelegate.h"

@interface PGCAppDelegate (AppService)

/**
 *  检查更新
 */
- (void)checkAppUpDataWithshowOption:(BOOL)showOption;
/**
 注册微信支付
 */
- (void)registerWeChatPay;
/**
 注册三方分享
 */
- (void)registerShare;
/**
 *  注册高德地图
 */
- (void)registerAMap;
/**
 *  注册个推
 */
- (void)registerGeTui;

@end
