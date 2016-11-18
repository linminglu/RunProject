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
#pragma mark - 上传图片

+ (NSURLSessionDataTask *)uploadRequest:(NSString *)urlString parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(HttpProgress)progress success:(successHandler)success failure:(failureHandler)failure
{
    NSString *url = [kBaseURL stringByAppendingString:urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *file = [formatter stringFromDate:[NSDate date]];
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSString *imageName = [NSString stringWithFormat:@"%@%lu.%@", fileName ? fileName : file, (unsigned long)idx, mimeType ? mimeType : @"jpg"];
            [formData appendPartWithFileData:imageData name:name fileName:imageName mimeType:[NSString stringWithFormat:@"image/%@", mimeType ? mimeType : @"jpg"]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(task, responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(task, error) : nil;
    }];
}



#pragma mark -
#pragma mark - 网络请求统一处理

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
    
    YYCache *cache = [YYCache cacheWithName:PGCHttpCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = true;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = true;
    
    id cacheData = [cache objectForKey:cacheKey];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [PGCProgressHUD showMessage:@"未识别的网络" toView:KeyWindow];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [PGCProgressHUD showMessage:@"网络错误(未连接)" toView:KeyWindow];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
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
                if (![self requestBeforeJudgeConnect]) {
                    success(nil, cacheData);
                }
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
    return [self requestType:requestType urlString:url parameters:parameters cache:cache cacheKey:cacheKey success:success failure:failure];
}


+ (NSURLSessionDataTask *)requestType:(RequestType)requestType
                            urlString:(NSString *)urlString
                           parameters:(NSDictionary *)parameters
                                cache:(YYCache *)cache
                             cacheKey:(NSString *)cacheKey
                              success:(successHandler)success
                              failure:(failureHandler)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    switch (requestType) {
        case RequestType_GET:
            return [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSError *error;
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                }
                success ? success(task, responseObject) : nil;
                [cache setObject:responseObject forKey:cacheKey withBlock:nil];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure ? failure(task, error) : nil;
                // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            }];
            break;
        case RequestType_POST:
            return [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                
                if ([responseObject isKindOfClass:[NSData class]]) { 
                    NSError *error;
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                }
                success ? success(task, responseObject) : nil;
                [cache setObject:responseObject forKey:cacheKey withBlock:nil];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure ? failure(task, error) : nil;
                // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            }];
        default:
            return nil;
            break;
    }
}



#pragma mark -
#pragma mark - Public

+ (void)removeAllCache {
    [[YYCache cacheWithName:PGCHttpCache].diskCache removeAllObjects];
}


+ (NSInteger)getAllCacheSize
{
    return [[YYCache cacheWithName:PGCHttpCache].diskCache totalCost];
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data
{
    if (!data) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark -
#pragma mark - 网络判断

+ (BOOL)requestBeforeJudgeConnect
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return false;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? true : false;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;/*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
    });
    return isNetworkEnable;
}


@end



