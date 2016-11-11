//
//  PGCInterfaceConfig.m
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCInterfaceConfig.h"

NSString *const kBaseURL = @"http://192.168.0.249:8080/zbapp/mobile/api/";


#pragma mark - 注册登录
// 获取验证码
NSString *const kSendVerifyCodeURL = @"open/sendVerifyCode.htm";
// 注册
NSString *const kUserRegist = @"user/open/userRegist.htm";
// 登录
NSString *const kUserLogin = @"user/open/userLogin.htm";
// 上传推送信息
NSString *const kUserPushInfo = @"user/access/userPushInfo.htm";
// 忘记密码
NSString *const kUserForgetPassword = @"user/open/userForgetPassword.htm";
// 退出登录
NSString *const kUserLogout = @"user/access/userLogout.htm";
// 更新用户session
NSString *const kUserUpdateSession = @"user/access/userUpdateSession.htm";


#pragma mark - 用户信息
// 修改个人信息
NSString *const kUserCompleteInfo = @"user/access/userCompleteInfo.htm";


#pragma mark - 地区-省市
// 获取省
NSString *const kGetProvinces = @"open/getProvinces.htm";
// 获取市
NSString *const kGetCities = @"open/getCities.htm";


#pragma mark - 项目
// 项目类型
NSString *const kGetProjectTypes = @"open/getProjectTypes.htm";
// 项目进度
NSString *const kGetProjectProgresses = @"open/getProjectProgresses.htm";
// 项目列表
NSString *const kGetProjects = @"open/getProjects.htm";
// 获取项目联系人
NSString *const kGetProjectContacts = @"open/getProjectContacts.htm";
// 添加收藏与浏览记录
NSString *const kAddAccessOrCollect = @"access/addAccessOrCollect.htm";
// 删除收藏与浏览记录
NSString *const kDeleteAccessOrCollect = @"access/deleteAccessOrCollect.htm";
// 获取收藏与浏览记录
NSString *const kGetAccessOrCollect = @"access/getAccessOrCollect.htm";


#pragma mark - 供需
// 类别
NSString *const kGetMaterialServiceTypes = @"open/getMaterialServiceTypes.htm";
// 添加需求
NSString *const kAddDemand = @"access/addDemand.htm";
// 需求列表
NSString *const kGetDemand = @"access/getDemand.htm";
// 添加供应
NSString *const kAddSupply = @"access/addSupply.htm";
// 供应列表
NSString *const kGetSupply = @"access/getSupply.htm";
// 添加收藏
NSString *const kAddSupplyDemandCollect = @"access/addSupplyDemandCollect.htm";
// 删除收藏
NSString *const kDeleteSupplyDemandCollect = @"access/deleteSupplyDemandCollect.htm";
// 获取收藏
NSString *const kGetSupplyDemandCollect = @"access/getSupplyDemandCollect.htm";
// 我发布的需求
NSString *const kMyDemands = @"access/myDemands.htm";
// 我发布的供应
NSString *const kMySupplies = @"access/mySupplies.htm";
// 删除我的需求
NSString *const kDeleteMyDemands = @"access/deleteMyDemands.htm";
// 关闭我的供应
NSString *const kCloseMySupply = @"access/closeMySupply.htm";


#pragma mark - 联系人
// 添加联系人
NSString *const kAddContact = @"access/addContact.htm";
// 获取联系人
NSString *const kGetContactsList = @"access/getContactsList.htm";
// 删除联系人
NSString *const kDeleteContact = @"access/deleteContact.htm";

#pragma mark - 会员
// 购买会员
NSString *const kBuyVip = @"access/buyVip.htm";
// 广告轮播
NSString *const kAdList = @"open/adList.htm";
// 软件更新
NSString *const kGetNewVersion = @"open/getNewVersion.htm";
// 意见反馈
NSString *const kFeedback = @"open/feedback.htm";
#warning 此处链接不同
// 图片上传
NSString *const kSignleImageUpload = @"/signleImageUpload.htm";


@implementation PGCInterfaceConfig

@end
