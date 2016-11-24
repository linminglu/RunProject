//
//  PGCInterfaceConfig.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBaseURL;
extern NSString *const kBaseImageURL;

#pragma mark - 注册登录

UIKIT_EXTERN NSString *const kSendVerifyCodeURL;// 获取验证码

UIKIT_EXTERN NSString *const kUserRegist;// 注册

UIKIT_EXTERN NSString *const kUserLogin;// 登录

UIKIT_EXTERN NSString *const kUserPushInfo;// 上传推送信息

UIKIT_EXTERN NSString *const kUserForgetPassword;// 忘记密码

UIKIT_EXTERN NSString *const kUserLogout;// 退出登录

UIKIT_EXTERN NSString *const kUserUpdateSession;// 更新用户session


#pragma mark - 用户信息

UIKIT_EXTERN NSString *const kUserCompleteInfo;// 修改个人信息


#pragma mark - 地区-省市

UIKIT_EXTERN NSString *const kGetProvinces;// 获取省

UIKIT_EXTERN NSString *const kGetCities;// 获取市


#pragma mark - 项目

UIKIT_EXTERN NSString *const kGetProjectTypes;// 项目类型

UIKIT_EXTERN NSString *const kGetProjectProgresses;// 项目进度

UIKIT_EXTERN NSString *const kGetProjects;// 项目列表

UIKIT_EXTERN NSString *const kGetProjectContacts;// 获取项目联系人

UIKIT_EXTERN NSString *const kAddAccessOrCollect;// 添加收藏与浏览记录

UIKIT_EXTERN NSString *const kDeleteAccessOrCollect;// 删除收藏与浏览记录

UIKIT_EXTERN NSString *const kGetAccessOrCollect;// 获取收藏与浏览记录

UIKIT_EXTERN NSString *const kGetNearProjects;// 地图项目


#pragma mark - 供需

UIKIT_EXTERN NSString *const kGetMaterialServiceTypes;// 类别

UIKIT_EXTERN NSString *const kAddOrMidifyDemand;// 添加/修改 需求

UIKIT_EXTERN NSString *const kGetDemand;// 需求列表

UIKIT_EXTERN NSString *const kAddOrMidifySupply;// 添加/修改 供应

UIKIT_EXTERN NSString *const kGetSupply;// 供应列表

UIKIT_EXTERN NSString *const kAddSupplyDemandCollect;// 添加收藏

UIKIT_EXTERN NSString *const kDeleteSupplyDemandCollect;// 删除收藏

UIKIT_EXTERN NSString *const kGetSupplyDemandCollect;// 获取收藏

UIKIT_EXTERN NSString *const kMyDemands;// 我发布的需求

UIKIT_EXTERN NSString *const kMySupplies;// 我发布的供应

UIKIT_EXTERN NSString *const kDeleteMyDemands;// 删除我的需求

UIKIT_EXTERN NSString *const kCloseMySupply;// 关闭我的供应


#pragma mark - 联系人

UIKIT_EXTERN NSString *const kAddContact;// 添加联系人

UIKIT_EXTERN NSString *const kGetContactsList;// 获取联系人

UIKIT_EXTERN NSString *const kDeleteContact;// 删除联系人


#pragma mark - 会员

UIKIT_EXTERN NSString *const kBuyVip;// 购买会员

UIKIT_EXTERN NSString *const kGetVipProductList;//获取产品列表


#pragma mark - 其他

UIKIT_EXTERN NSString *const kAdList;// 广告轮播

UIKIT_EXTERN NSString *const kGetNewVersion;// 软件更新

UIKIT_EXTERN NSString *const kFeedback;// 意见反馈

UIKIT_EXTERN NSString *const kSignleImageUpload;// 图片上传

UIKIT_EXTERN NSString *const kGetLatestAppSplashImage;//获取启动图片


@interface PGCInterfaceConfig : NSObject

@end
