//
//  PGCSupplyAndDemandAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandAPIManager.h"

@implementation PGCSupplyAndDemandAPIManager

+ (NSURLSessionDataTask *)getMaterialServiceTypesWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{    
    return [self requestPOST:kGetMaterialServiceTypes parameters:parameters cachePolicy:RequestReturnCacheDataElseLoad success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            respondsBlock(RespondsStatusSuccess, resultMsg, resultData);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}

@end
