//
//  PGCAreaAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCAreaAPIManager : PGCBaseAPIManager

// 获取省
+ (NSURLSessionDataTask *)getProvincesRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 获取市
+ (NSURLSessionDataTask *)getCitiesRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, NSMutableArray *resultData))respondsBlock;

@end
