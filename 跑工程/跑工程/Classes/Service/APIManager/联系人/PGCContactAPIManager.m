//
//  PGCContactAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactAPIManager.h"

@implementation PGCContactAPIManager

+ (NSURLSessionDataTask *)addContactRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kAddContact parameters:parameters cachePolicy:RequestReloadIngnoringLocalCacheData success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)getContactsListRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kGetContactsList parameters:parameters cachePolicy:RequestReloadIngnoringLocalCacheData success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)deleteContactRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kDeleteContact parameters:parameters cachePolicy:RequestReloadIngnoringLocalCacheData success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
