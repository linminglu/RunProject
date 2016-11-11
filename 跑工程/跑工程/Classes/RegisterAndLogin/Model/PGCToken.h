//
//  PGCToken.h
//  跑工程
//
//  Created by leco on 2016/11/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGCUserInfo.h"

@interface PGCToken : NSObject

@property (assign, nonatomic) BOOL isLogin;/** 是否登录 */
@property (copy, nonatomic) NSString *token;/** 用户token信息 */
@property (assign, nonatomic) long timestamp;/** timestamp */
@property (assign, nonatomic) int valid;/** valid */
@property (strong, nonatomic) PGCUserInfo *user;/** 用户信息 */

+ (instancetype)token;

@end
