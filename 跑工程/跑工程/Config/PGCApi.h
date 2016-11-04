//
//  PGCApi.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#ifndef PGCApi_h
#define PGCApi_h

/***
 服务器返回结果统一用MsgJson封装，MsgJson定义如下
 {
 code:200; // 状态编码
 message:”信息”; // 服务器返回错误信息
 data:{} // json数据
 }
 ***/

#pragma mark *** 注册登录 ***
static NSString *const baseURL = @"http://192.168.0.180:8080/zbapp";
// 获取验证码
static NSString *const sendVerifyCodeURL = @"/mobile/api/open/sendVerifyCode.htm";
// 注册
static NSString *const userRegist = @"/mobile/api/user/open/userRegist.htm";


#endif /* PGCApi_h */
