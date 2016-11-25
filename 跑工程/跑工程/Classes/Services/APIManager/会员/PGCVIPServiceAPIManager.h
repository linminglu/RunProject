//
//  PGCVIPServiceAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCVIPServiceAPIManager : PGCBaseAPIManager

// 购买会员
+ (NSURLSessionDataTask *)buyVipRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 获取产品列表
+ (NSURLSessionDataTask *)getVipProductListRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, NSMutableArray *resultData))respondsBlock;

@end
