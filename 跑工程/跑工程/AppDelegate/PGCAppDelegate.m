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
    
    [self setAppWindow];// 初始化window
    
    [self setRootViewController];// 设置根视图控制器
        
    [self registerShare];// 注册三方分享
    
    [self registerAMap];// 注册高德地图
    
    [self registerGeTui];// 注册个推
    
    [self.window makeKeyAndVisible];
    
    return true;
}


@end
