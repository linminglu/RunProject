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

@interface PGCAppDelegate ()

@end

@implementation PGCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 检查更新
    [self checkAppUpDataWithshowOption:false];
    // 初始化window
    [self setAppWindow];
    // 设置根视图控制器
    [self setRootViewController];
    // 注册高德地图
    [self registerAMap];
    // 获取基本数据
    [self configLaunchingUserData];
    // 设置主窗口并显示在屏幕上
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
