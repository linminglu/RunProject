//
//  PGCAppDelegate.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
// 微信SDK头文件
#import "WXApi.h"
// 个推SDK头文件
#import "GeTuiSdk.h"
// iOS10 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface PGCAppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, WXApiDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
