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


@end
