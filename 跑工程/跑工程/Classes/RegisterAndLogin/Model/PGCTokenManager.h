//
//  PGCTokenManager.h
//  跑工程
//
//  Created by leco on 2016/11/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGCToken.h"

@interface PGCTokenManager : NSObject

@property (strong, nonatomic) PGCToken *token;/** 用户的token */

+ (instancetype)tokenManager;

//从本地读取登录缓存信息
- (void)readAuthorizeData;
//把登录信息存入本地
- (void)saveAuthorizeData;
//登出
- (void)logout;

@end
