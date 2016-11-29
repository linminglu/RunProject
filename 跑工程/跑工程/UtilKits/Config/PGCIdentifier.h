//
//  PGCIdentifier.h
//  跑工程
//
//  Created by leco on 2016/11/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kProfileNotification;//我 控制器
extern NSString * const kReloadProfileInfo;// 修改个人资料 的通知

extern NSString * const kRefreshCollectTable;// 项目收藏 的通知
extern NSString * const kSearchProjectData;// 搜索项目的通知

extern NSString * const kContactReloadData;// 删除联系人 的通知

extern NSString * const kProcurementInfoData;//收藏招标信息的通知
extern NSString * const kSupplyInfoData;//收藏供应信息的通知





@interface PGCIdentifier : NSObject

@end
