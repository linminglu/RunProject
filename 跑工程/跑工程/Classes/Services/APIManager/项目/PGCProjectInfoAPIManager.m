//
//  PGCProjectInfoAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoAPIManager.h"
#import "PGCProjectManager.h"
#import "PGCProjectInfo.h"
#import "PGCProjectContact.h"

@implementation PGCProjectInfoAPIManager

+ (NSURLSessionDataTask *)getProjectTypesRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, NSMutableArray *))respondsBlock
{
    return [self requestPOST:kGetProjectTypes parameters:parameters cachePolicy:RequestReturnCacheDataThenLoad success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            NSMutableArray *typeArr = [NSMutableArray array];
            for (id value in resultData) {
                PGCProjectType *projectType = [[PGCProjectType alloc] init];
                [projectType mj_setKeyValues:value];
                // 将模型添加到数组中
                [typeArr addObject:projectType];
            }
            [PGCProjectManager manager].projectTypes = typeArr;
            
            respondsBlock(RespondsStatusSuccess, resultMsg, typeArr);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)getProjectProgressesRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, NSMutableArray *))respondsBlock
{
    return [self requestPOST:kGetProjectProgresses parameters:parameters cachePolicy:RequestReturnCacheDataThenLoad success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            NSMutableArray *progressArr = [NSMutableArray array];
            for (id value in resultData) {
                PGCProjectProgress *progress = [[PGCProjectProgress alloc] init];
                [progress mj_setKeyValues:value];
                // 将模型添加到数组中
                [progressArr addObject:progress];
            }
            [PGCProjectManager manager].projectProgresses = progressArr;
            
            respondsBlock(RespondsStatusSuccess, resultMsg, progressArr);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)getProjectsRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kGetProjects parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // code = 200   请求成功返回，数据查询正常，但data不一定有数据
        // code = -200  请求不成功，服务器由于一些原因执行中无法返回数据
        // code = -201  用户不存在或被禁用，手机端退出用户登陆
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            NSMutableArray *results = [NSMutableArray array];
            for (id value in resultData[@"result"]) {
                PGCProjectInfo *project = [[PGCProjectInfo alloc] init];
                [project mj_setKeyValues:value];
                // 将模型添加到数组中
                [results addObject:project];
            }
            respondsBlock(RespondsStatusSuccess, resultMsg, resultData);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"网络错误(未连接)" toView:KeyWindow];
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)getProjectContactsRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, NSMutableArray *))respondsBlock
{
    return [self requestPOST:kGetProjectContacts parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            NSMutableArray *results = [NSMutableArray array];
            for (id value in resultData) {
                PGCProjectContact *contact = [[PGCProjectContact alloc] init];
                [contact mj_setKeyValues:value];
                // 将模型添加到数组中
                [results addObject:contact];
            }
            respondsBlock(RespondsStatusSuccess, resultMsg, results);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"网络错误(未连接)" toView:KeyWindow];
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)addAccessOrCollectRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
   return [self requestPOST:kAddAccessOrCollect parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)deleteAccessOrCollectRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kDeleteAccessOrCollect parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)getAccessOrCollectRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kGetAccessOrCollect parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        [MBProgressHUD showError:@"网络错误(未连接)" toView:KeyWindow];
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)getNearProjectsRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kGetNearProjects parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
