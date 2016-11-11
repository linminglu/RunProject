//
//  PGCProjectInfoAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"
#import "PGCNetworkHelper.h"

@interface PGCProjectInfoAPIManager : PGCBaseAPIManager

// 获取项目类型
+ (NSURLSessionDataTask *)getProjectTypesRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 获取项目进度
+ (NSURLSessionDataTask *)getProjectProgressesRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 获取项目信息
+ (NSURLSessionDataTask *)getProjectsRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 获取项目联系人
+ (NSURLSessionDataTask *)getProjectContactsRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 添加收藏与浏览记录
+ (NSURLSessionDataTask *)addAccessOrCollectRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 删除收藏与浏览记录
+ (NSURLSessionDataTask *)deleteAccessOrCollectRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 获取收藏与浏览记录
+ (NSURLSessionDataTask *)getAccessOrCollectRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


@end
