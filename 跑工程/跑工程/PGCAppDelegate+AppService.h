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
 *  基本配置
 */
- (void)configurationLaunchUserOption;
/**
 *  注册高德地图 pod 'AMap2DMap'
 */
- (void)registerAMap;

/**
 *  检查更新
 */
- (void)checkAppUpDataWithshowOption:(BOOL)showOption;
/**
 *  上传用户设备信息
 */
- (void)upLoadMessageAboutUser;
/**
 *  检查黑名单用户
 */
- (void)checkBlack;

@end
