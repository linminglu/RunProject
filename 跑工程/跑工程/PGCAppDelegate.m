//
//  PGCAppDelegate.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAppDelegate.h"
#import "PGCAppDelegate+AppService.h"
#import "PGCAppDelegate+AppLifeCircle.h"
#import "PGCAppDelegate+RootController.h"

#import "PGCTabBarController.h"

@interface PGCAppDelegate ()

@end

@implementation PGCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化window
    [self setAppWindow];
    // 设置根视图控制器
    [self setRootViewController];
    // 基本配置
    [self configurationLaunchUserOption];
    // 注册高德地图
    [self registerAMap];
    // 上传用户设备信息
    [self upLoadMessageAboutUser];
    // 检查更新
    [self checkAppUpDataWithshowOption:NO];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
