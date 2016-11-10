//
//  PGCUserInfo.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCUserInfo : NSObject

/**
 电话
 */
@property (copy, nonatomic) NSString *phone;
/**
 姓名
 */
@property (copy, nonatomic) NSString *name;
/**
 身份证
 */
@property (assign, nonatomic) NSInteger id_card;
/**
 头像
 */
@property (copy, nonatomic) NSString *headimage;
/**
 性别
 */
@property (assign, nonatomic) NSInteger sex;
/**
 职位
 */
@property (copy, nonatomic) NSString *post;
/**
 公司
 */
@property (copy, nonatomic) NSString *company;
/**
 是不是会员
 */
@property (assign, nonatomic) NSInteger is_vip;
/**
 vip 到期时间
 */
@property (copy, nonatomic) NSString *vip_expired;


- (instancetype)initWithDic:(NSDictionary*)dic;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

/**
 清除用户信息
 */
+ (void)clearUserInfo;
/**
 重新登录
 */
+ (void)reLogin;
/**
 刷新用户信息

 @param key
 @param value
 */
+ (void)refreshUserMessageWithKey:(NSString *)key value:(NSString *)value;

@end
