//
//  PGCAppDelegate+AppService.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAppDelegate+AppService.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "PGCOtherAPIManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@implementation PGCAppDelegate (AppService)

- (void)registerShare
{
    [ShareSDK registerApp:SHARE_APPKEY activePlatforms:@[@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType) {
            case SSDKPlatformTypeWechat: [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ: [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType) {
            case SSDKPlatformTypeWechat: [appInfo SSDKSetupWeChatByAppId:WeChat_APPID appSecret:SHARE_SECRET];
                break;
            case SSDKPlatformTypeQQ: [appInfo SSDKSetupQQByAppId:QQ_APPID appKey:QQ_APPKEY authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

- (void)registerAMap
{
    [AMapServices sharedServices].apiKey = AMapKey;
}

- (void)registerGeTui
{
    [GeTuiSdk startSdkWithAppId:GETUI_APPID appKey:GETUI_APPKEY appSecret:GETUI_APPSECRET delegate:self];
    
    [self registerRemoteNotification];
}

#pragma mark - 用户通知(推送) _自定义方法
/** 注册远程通知 */
- (void)registerRemoteNotification
{
    /*
     警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     
     警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     */
    if (FSystemVersion >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    }
    else if (FSystemVersion >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |  UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}


- (void)checkAppUpDataWithshowOption:(BOOL)showOption
{
    [PGCOtherAPIManager getNewVersionRequestWithParameters:@{@"type":@2} responds:^(RespondsStatus status, NSString *message, id resultData) {
        NSLog(@"%@", message);
    }];
}

@end
