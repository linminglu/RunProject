//
//  PGCInterfaceConfig.m
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCInterfaceConfig.h"

//工程信息管理系统
NSString *const kBaseURL = @"http://gcb.letide.cn";
NSString *const kBaseImageURL = @"http://gcb.letide.cn";
//NSString *const kBaseURL = @"http://192.168.0.154:8080/zbapp";
//NSString *const kBaseImageURL = @"http://192.168.0.154:8080";

#pragma mark - 注册登录
// 获取验证码
NSString *const kSendVerifyCodeURL = @"/mobile/api/open/sendVerifyCode.htm";
// 注册
NSString *const kUserRegist = @"/mobile/api/user/open/userRegist.htm";
// 登录
NSString *const kUserLogin = @"/mobile/api/user/open/userLogin.htm";
// 上传推送信息
NSString *const kUserPushInfo = @"/mobile/api/user/access/userPushInfo.htm";
// 忘记密码
NSString *const kUserForgetPassword = @"/mobile/api/user/open/userForgetPassword.htm";
// 退出登录
NSString *const kUserLogout = @"/mobile/api/user/access/userLogout.htm";
// 更新用户session
NSString *const kUserUpdateSession = @"/mobile/api/user/access/userUpdateSession.htm";


#pragma mark - 用户信息
// 修改个人信息
NSString *const kUserCompleteInfo = @"/mobile/api/user/access/userCompleteInfo.htm";


#pragma mark - 地区-省市
// 获取省
NSString *const kGetProvinces = @"/mobile/api/open/getProvinces.htm";
// 获取市
NSString *const kGetCities = @"/mobile/api/open/getCities.htm";


#pragma mark - 项目
// 项目类型
NSString *const kGetProjectTypes = @"/mobile/api/open/getProjectTypes.htm";
// 项目进度
NSString *const kGetProjectProgresses = @"/mobile/api/open/getProjectProgresses.htm";
// 项目列表
NSString *const kGetProjects = @"/mobile/api/open/getProjects.htm";
// 获取项目联系人
NSString *const kGetProjectContacts = @"/mobile/api/open/getProjectContacts.htm";
// 添加收藏与浏览记录
NSString *const kAddAccessOrCollect = @"/mobile/api/access/addAccessOrCollect.htm";
// 删除收藏与浏览记录
NSString *const kDeleteAccessOrCollect = @"/mobile/api/access/deleteAccessOrCollect.htm";
// 获取收藏与浏览记录
NSString *const kGetAccessOrCollect = @"/mobile/api/access/getAccessOrCollect.htm";


#pragma mark - 供需
// 类别
NSString *const kGetMaterialServiceTypes = @"/mobile/api/open/getMaterialServiceTypes.htm";
// 添加/修改 需求
NSString *const kAddOrMidifyDemand = @"/mobile/api/access/addOrMidifyDemand.htm";
// 需求列表
NSString *const kGetDemand = @"/mobile/api/access/getDemand.htm";
// 添加/修改 供应
NSString *const kAddOrMidifySupply = @"/mobile/api/access/addOrMidifySupply.htm";
// 供应列表
NSString *const kGetSupply = @"/mobile/api/access/getSupply.htm";
// 添加收藏
NSString *const kAddSupplyDemandCollect = @"/mobile/api/access/addSupplyDemandCollect.htm";
// 删除收藏
NSString *const kDeleteSupplyDemandCollect = @"/mobile/api/access/deleteSupplyDemandCollect.htm";
// 获取收藏
NSString *const kGetSupplyDemandCollect = @"/mobile/api/access/getSupplyDemandCollect.htm";
// 我发布的需求
NSString *const kMyDemands = @"/mobile/api/access/myDemands.htm";
// 我发布的供应
NSString *const kMySupplies = @"/mobile/api/access/mySupplies.htm";
// 删除我的需求
NSString *const kDeleteMyDemands = @"/mobile/api/access/deleteMyDemands.htm";
// 关闭我的供应
NSString *const kCloseMySupply = @"/mobile/api/access/closeMySupply.htm";


#pragma mark - 联系人
// 添加联系人
NSString *const kAddContact = @"/mobile/api/access/addContact.htm";
// 获取联系人
NSString *const kGetContactsList = @"/mobile/api/access/getContactsList.htm";
// 删除联系人
NSString *const kDeleteContact = @"/mobile/api/access/deleteContact.htm";

#pragma mark - 会员
// 购买会员
NSString *const kBuyVip = @"/mobile/api/access/buyVip.htm";
// 广告轮播
NSString *const kAdList = @"/mobile/api/open/adList.htm";
// 软件更新
NSString *const kGetNewVersion = @"/mobile/api/open/getNewVersion.htm";
// 意见反馈
NSString *const kFeedback = @"/mobile/api/open/feedback.htm";
// 图片上传
NSString *const kSignleImageUpload = @"/signleImageUpload.htm";
// 获取启动图片
NSString *const kGetLatestAppSplashImage = @"/mobile/api/open/getLatestAppSplashImage.htm";

@implementation PGCInterfaceConfig

@end
