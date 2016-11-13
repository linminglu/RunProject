//
//  PGCTokenManager.m
//  跑工程
//
//  Created by leco on 2016/11/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCTokenManager.h"
#import "PGCDataCache.h"

@implementation PGCTokenManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)tokenManager {
    static PGCTokenManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PGCTokenManager alloc] init];
    });
    return manager;
}

- (void)readAuthorizeData {
    _token = [PGCDataCache cacheForKey:@"TokenCache"];
    if (!_token) {
        _token = [[PGCToken alloc] init];
    }
}

- (void)saveAuthorizeData {
    [PGCDataCache setCache:_token forKey:@"TokenCache"];
}

- (void)logout {
    //登录模块重新初始化
    _token = [[PGCToken alloc] init];
    _token.firstUseSoft = false;
    [self saveAuthorizeData];
}

@end
