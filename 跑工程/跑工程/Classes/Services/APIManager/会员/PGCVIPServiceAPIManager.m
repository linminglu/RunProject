//
//  PGCVIPServiceAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCVIPServiceAPIManager.h"
#import "PGCProduct.h"

@implementation PGCVIPServiceAPIManager


+ (NSURLSessionDataTask *)buyVipRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kBuyVip parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)getVipProductListRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, NSMutableArray *))respondsBlock
{
    return [self requestPOST:kGetVipProductList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            NSMutableArray *results = [NSMutableArray array];
            for (id value in resultData) {
                PGCProduct *product = [[PGCProduct alloc] init];
                [product mj_setKeyValues:value];
                [results addObject:product];
            }
            respondsBlock(RespondsStatusSuccess, resultMsg, results);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription toView:KeyWindow];
        
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


@end
