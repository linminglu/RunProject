//
//  PGCInterfaceConfig.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBaseURL;


#pragma mark - 注册登录

extern NSString *const kSendVerifyCodeURL;// 获取验证码

extern NSString *const kUserRegist;// 注册

extern NSString *const kUserLogin;// 登录

extern NSString *const kUserPushInfo;// 上传推送信息

extern NSString *const kUserForgetPassword;// 忘记密码

extern NSString *const kUserLogout;// 退出登录

extern NSString *const kUserUpdateSession;// 更新用户session


#pragma mark - 用户信息

extern NSString *const kUserCompleteInfo;// 修改个人信息


#pragma mark - 地区-省市

extern NSString *const kGetProvinces;// 获取省

extern NSString *const kGetCities;// 获取市


#pragma mark - 项目

extern NSString *const kGetProjectTypes;// 项目类型

extern NSString *const kGetProjectProgresses;// 项目进度

extern NSString *const kGetProjects;// 项目列表

extern NSString *const kGetProjectContacts;// 获取项目联系人

extern NSString *const kAddAccessOrCollect;// 添加收藏与浏览记录

extern NSString *const kDeleteAccessOrCollect;// 删除收藏与浏览记录

extern NSString *const kGetAccessOrCollect;// 获取收藏与浏览记录



#pragma mark - 供需

extern NSString *const kGetMaterialServiceTypes;// 类别

extern NSString *const kAddOrMidifyDemand;// 添加/修改 需求

extern NSString *const kGetDemand;// 需求列表

extern NSString *const kAddOrMidifySupply;// 添加/修改 供应

extern NSString *const kGetSupply;// 供应列表

extern NSString *const kAddSupplyDemandCollect;// 添加收藏

extern NSString *const kDeleteSupplyDemandCollect;// 删除收藏

extern NSString *const kGetSupplyDemandCollect;// 获取收藏

extern NSString *const kMyDemands;// 我发布的需求

extern NSString *const kMySupplies;// 我发布的供应

extern NSString *const kDeleteMyDemands;// 删除我的需求

extern NSString *const kCloseMySupply;// 关闭我的供应


#pragma mark - 联系人

extern NSString *const kAddContact;// 添加联系人

extern NSString *const kGetContactsList;// 获取联系人

extern NSString *const kDeleteContact;// 删除联系人


#pragma mark - 会员

extern NSString *const kBuyVip;// 购买会员

extern NSString *const kAdList;// 广告轮播

extern NSString *const kGetNewVersion;// 软件更新

extern NSString *const kFeedback;// 意见反馈

extern NSString *const kSignleImageUpload;// 图片上传

extern NSString *const kGetLatestAppSplashImage;//获取启动图片


@interface PGCInterfaceConfig : NSObject

@end
