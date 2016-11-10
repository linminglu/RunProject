//
//  PGCBaseAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

/* YYCahce缓存name */
static NSString * const PGCHttpCache = @"HttpYYCache";


@implementation PGCBaseAPIManager


#pragma mark -
#pragma mark - GET

+ (NSURLSessionDataTask *)requestGET:(NSString *)urlString parameters:(NSDictionary *)parameters success:(successHandler)success failure:(failureHandler)failure
{
    return [self requestType:RequestType_GET urlString:urlString parameters:parameters cachePolicy:RequestReloadIngnoringLocalCacheData success:success failure:failure];
}

+ (NSURLSessionDataTask *)requestGET:(NSString *)urlString parameters:(NSDictionary *)parameters cachePolicy:(RequestCachePolicy)cachePolicy success:(successHandler)success failure:(failureHandler)failure
{
    return [self requestType:RequestType_GET urlString:urlString parameters:parameters cachePolicy:cachePolicy success:success failure:failure];
}



#pragma mark -
#pragma mark - POST

+ (NSURLSessionDataTask *)requestPOST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(successHandler)success failure:(failureHandler)failure
{
    return [self requestType:RequestType_POST urlString:urlString parameters:parameters cachePolicy:RequestReloadIngnoringLocalCacheData success:success failure:failure];
}

+ (NSURLSessionDataTask *)requestPOST:(NSString *)urlString parameters:(NSDictionary *)parameters cachePolicy:(RequestCachePolicy)cachePolicy success:(successHandler)success failure:(failureHandler)failure
{
    return [self requestType:RequestType_POST urlString:urlString parameters:parameters cachePolicy:cachePolicy success:success failure:failure];
}



#pragma mark -
#pragma mark - Private

+ (NSURLSessionDataTask *)requestType:(RequestType)requestType
                            urlString:(NSString *)urlString
                           parameters:(NSDictionary *)parameters
                          cachePolicy:(RequestCachePolicy)cachePolicy
                              success:(successHandler)success
                              failure:(failureHandler)failure
{
    // 拼接URL链接
    NSString *url = [kBaseURL stringByAppendingString:urlString];
    // 处理中文和空格问题
    NSString *cacheKey = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (parameters) {
        if (![NSJSONSerialization isValidJSONObject:parameters]) {
            return nil;
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cacheKey = [url stringByAppendingString:paramString];
    }
    
    YYCache *cache = [[YYCache alloc] initWithName:PGCHttpCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning        = true;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = true;
    
    id cacheData = [cache objectForKey:cacheKey];
    
    switch (cachePolicy) {
        case RequestReturnCacheDataThenLoad:
            if (cacheData) {
                success(nil, cacheData);
            }
            break;
        case RequestReloadIngnoringLocalCacheData:
            break;
        case RequestReturnCacheDataElseLoad:
            if (cacheData) {
                success(nil, cacheData);
            }
            break;
        case RequestReturnCacheDataDontLoad:
            if (cacheData) {
                success(nil, cacheData);
            }
            return nil;
            break;
        default:
            break;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    switch (requestType) {
        case RequestType_GET:
            return [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSError *error;
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                }
                [cache setObject:responseObject forKey:cacheKey];
                success(task, responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failure(task, error);
                // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            }];
            break;
        case RequestType_POST:
            return [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSError *error;
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                }
                [cache setObject:responseObject forKey:cacheKey];
                success(task, responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failure(task, error);
                // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            }];
        default:
            break;
    }
    return nil;
}



#pragma mark -
#pragma mark - Public

+ (void)removeAllCache {
    [[YYCache cacheWithName:PGCHttpCache] removeAllObjects];
}



@end
