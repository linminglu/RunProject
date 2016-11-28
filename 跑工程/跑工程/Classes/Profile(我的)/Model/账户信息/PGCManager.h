//
//  PGCManager.h
//  跑工程
//
//  Created by leco on 2016/11/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGCDataCache.h"
#import "PGCToken.h"

// 管理用户登录信息的工具
@interface PGCManager : NSObject

@property (strong, nonatomic) PGCToken *token;/** token */

+ (instancetype)manager;

//从本地读取登录缓存信息
- (void)readTokenData;

//把登录信息存入本地
- (void)saveTokenData;

//登出
- (void)logout;

@end
