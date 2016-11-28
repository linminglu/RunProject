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

@implementation PGCAppDelegate (AppService)

- (void)registerShare
{
    
}

- (void)registerAMap
{
    [AMapServices sharedServices].apiKey = (NSString *)AMapKey;
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
