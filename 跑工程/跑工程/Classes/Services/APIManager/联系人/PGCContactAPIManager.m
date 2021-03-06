//
//  PGCContactAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactAPIManager.h"
#import "PGCContact.h"
#import "PGCProject.h"

@implementation PGCContactAPIManager

+ (NSURLSessionDataTask *)addContactRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kAddContact parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)getContactsListRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, NSMutableArray *))respondsBlock
{
    return [self requestPOST:kGetContactsList parameters:parameters cachePolicy:RequestReloadIngnoringLocalCacheData success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            NSMutableArray *contactArr = [NSMutableArray array];
            for (id value in resultData) {
                PGCContact *contact = [[PGCContact alloc] init];
                [contact mj_setKeyValues:value];
                // 将模型添加到数组中
                [contactArr addObject:contact];
            }
            respondsBlock(RespondsStatusSuccess, resultMsg, contactArr);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription toView:KeyWindow];
        
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)getContactProjectsRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, NSMutableArray *))respondsBlock
{
    return [self requestPOST:kGetContactProjects parameters:parameters cachePolicy:RequestReloadIngnoringLocalCacheData success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            
            NSMutableArray *results = [NSMutableArray array];
            for (id value in resultData) {
                PGCProject *project = [[PGCProject alloc] init];
                [project mj_setKeyValues:value];
                // 将模型添加到数组中
                [results addObject:project];
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
