//
//  PGCIdentifier.m
//  跑工程
//
//  Created by leco on 2016/11/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIdentifier.h"

NSString * const kProfileNotification = @"ProfileNotification";//我 控制器
NSString * const kReloadProfileInfo = @"ReloadProfileInfo";// 修改个人资料 的通知

NSString * const kRefreshCollectTable = @"RefreshCollectTable";// 项目收藏 的通知
NSString * const kSearchProjectData = @"SearchProjectData";// 搜索项目的通知

NSString * const kReloadProjectsContact = @"ReloadProjectsContact";// 刷新项目联系人 的通知

NSString * const kContactReloadData = @"ContactReloadData";// 删除联系人 的通知

NSString * const kProcurementInfoData = @"ProcurementInfoData";//收藏招标信息 的通知
NSString * const kSupplyInfoData = @"SupplyInfoData";//收藏供应信息 的通知

NSString * const kVIP_Alipay = @"VIP_Alipay";// 支付宝支付回调 的通知
NSString * const kVIP_WeChatPay = @"VIP_eChatPay ";// 微信支付回调 的通知

@implementation PGCIdentifier

@end
