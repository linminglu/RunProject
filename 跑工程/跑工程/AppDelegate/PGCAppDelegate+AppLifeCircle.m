//
//  PGCAppDelegate+AppLifeCircle.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAppDelegate+AppLifeCircle.h"

@implementation PGCAppDelegate (AppLifeCircle)



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //程序切入后台,这里要注意GMT时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:sourceTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.lastTimeEnterBackGroundStr = [formatter stringFromDate:[NSDate date]];//当前时间
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:sourceTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:self.lastTimeEnterBackGroundStr];
    NSDate *now = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    NSTimeInterval intervalTime = [now timeIntervalSince1970] * 1 - [lastDate timeIntervalSince1970] * 1;
    if (intervalTime > (2 * 60 * 60)) {
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/***
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 收到本地通知
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"通知推送错误为: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 收到远程通知
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知
    [application registerForRemoteNotifications];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    //禁止横屏
    return UIInterfaceOrientationMaskPortrait;
}
***/


@end
