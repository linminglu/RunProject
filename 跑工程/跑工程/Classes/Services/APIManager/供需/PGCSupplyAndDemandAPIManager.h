//
//  PGCSupplyAndDemandAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCSupplyAndDemandAPIManager : PGCBaseAPIManager

// 获取类别
+ (NSURLSessionDataTask *)getMaterialServiceTypesWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 添加收藏
+ (NSURLSessionDataTask *)addSupplyDemandCollectWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 删除收藏
+ (NSURLSessionDataTask *)deleteSupplyDemandCollectWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 获取收藏
+ (NSURLSessionDataTask *)getSupplyDemandCollectWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


@end
