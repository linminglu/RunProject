//
//  PGCRegisterOrLoginAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCRegisterOrLoginAPIManager : PGCBaseAPIManager

// 获取验证码
+ (NSURLSessionDataTask *)sendVerifyCodeURLRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 用户注册
+ (NSURLSessionDataTask *)registerRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 用户登录
+ (NSURLSessionDataTask *)loginRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 上传推送信息
+ (NSURLSessionDataTask *)pushInfoRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 忘记密码
+ (NSURLSessionDataTask *)forgetPasswordRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 退出登录
+ (NSURLSessionDataTask *)logoutRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 更新用户session
+ (NSURLSessionDataTask *)updateSessionRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

@end
