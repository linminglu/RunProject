//
//  PGCSupplyAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCSupplyAPIManager : PGCBaseAPIManager

// 添加需求
+ (NSURLSessionDataTask *)addDemandWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 需求列表
+ (NSURLSessionDataTask *)getDemandWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 我发布的需求
+ (NSURLSessionDataTask *)myDemandsWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 删除我的需求
+ (NSURLSessionDataTask *)deleteMyDemandsWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

@end
