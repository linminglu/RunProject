//
//  PGCDemandAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCDemandAPIManager : PGCBaseAPIManager

// 添加供应
+ (NSURLSessionDataTask *)addSupplyWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 供应列表
+ (NSURLSessionDataTask *)getSupplyWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 发布的供应
+ (NSURLSessionDataTask *)mySuppliesWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 闭我的供应
+ (NSURLSessionDataTask *)closeMySupplyWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


@end
