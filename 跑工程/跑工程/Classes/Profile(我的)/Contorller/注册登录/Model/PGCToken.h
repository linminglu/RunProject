//
//  PGCToken.h
//  跑工程
//
//  Created by leco on 2016/11/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGCUser.h"

// 用户Token信息模型
@interface PGCToken : NSObject

@property (copy, nonatomic) NSString *token;/** 用户token信息 */
@property (assign, nonatomic) long timestamp;/** timestamp */
@property (assign, nonatomic) int valid;/** valid */
@property (strong, nonatomic) PGCUser *user;/** 用户信息 */

@property (nonatomic, assign) BOOL firstUseSoft;//是不是第一次使用软件
@property (nonatomic, strong) NSString *lastSoftVersion;//最近一次软件的版本号

@end
