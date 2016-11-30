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

//微信SDK头文件
#import "WXApi.h"

@implementation PGCAppDelegate (AppService)

- (void)registerWeChatPay
{
    [WXApi registerApp:WeChat_APPID withDescription:@"zbapp"];
}

- (void)registerShare
{
    [ShareSDK registerApp:SHARE_APPKEY activePlatforms:@[@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
            {
                [ShareSDKConnector connectWeChat:[WXApi class]];
            }
                break;
            case SSDKPlatformTypeQQ:
            {
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
            }
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
            {
                [appInfo SSDKSetupWeChatByAppId:WeChat_APPID
                                      appSecret:SHARE_SECRET];
            }
                break;
            case SSDKPlatformTypeQQ:
            {
                [appInfo SSDKSetupQQByAppId:QQ_APPID
                                     appKey:QQ_APPKEY
                                   authType:SSDKAuthTypeBoth];
            }
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
    
}

- (void)checkAppUpDataWithshowOption:(BOOL)showOption
{
    [PGCOtherAPIManager getNewVersionRequestWithParameters:@{@"type":@2} responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            
        }
    }];
}

@end
