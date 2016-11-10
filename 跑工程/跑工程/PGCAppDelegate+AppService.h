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
- (void)configLaunchingUserData;
/**
 *  注册高德地图
 */
- (void)registerAMap;
/**
 *  检查更新
 */
- (void)checkAppUpDataWithshowOption:(BOOL)showOption;


@end
