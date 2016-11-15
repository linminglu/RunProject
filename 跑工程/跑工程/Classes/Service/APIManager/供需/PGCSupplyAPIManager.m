//
//  PGCSupplyAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAPIManager.h"

@implementation PGCSupplyAPIManager

+ (NSURLSessionDataTask *)addDemandWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kAddDemand parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)getDemandWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kGetDemand parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)myDemandsWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kMyDemands parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)deleteMyDemandsWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kDeleteMyDemands parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
