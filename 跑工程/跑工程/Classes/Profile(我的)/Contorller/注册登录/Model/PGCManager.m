//
//  PGCManager.m
//  跑工程
//
//  Created by leco on 2016/11/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCManager.h"

@implementation PGCManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)manager {
    static PGCManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PGCManager alloc] init];
    });
    return manager;
}

- (void)readTokenData
{
    _token = [PGCDataCache cacheForKey:@"TokenCache"];
    if (!_token) {
        _token = [[PGCToken alloc] init];
    }
}

- (void)saveTokenData
{
    [PGCDataCache setCache:_token forKey:@"TokenCache"];
}

- (void)logout {
    //登录模块重新初始化
    _token = [[PGCToken alloc] init];
    _token.firstUseSoft = false;
    [self saveTokenData];
}

@end
