//
//  PGCAppDelegate+AppService.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAppDelegate+AppService.h"
#import <AMapFoundationKit/AMapFoundationKit.h>


@implementation PGCAppDelegate (AppService)

- (void)configLaunchingUserData
{
    
}


- (void)registerAMap
{
    [AMapServices sharedServices].apiKey = AMapKey;
}


- (void)checkAppUpDataWithshowOption:(BOOL)showOption
{
    
}


@end
