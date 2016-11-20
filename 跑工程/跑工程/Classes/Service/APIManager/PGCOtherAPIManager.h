//
//  PGCOtherAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCOtherAPIManager : PGCBaseAPIManager

// 广告轮播
+ (NSURLSessionDataTask *)adListRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 软件更新
+ (NSURLSessionDataTask *)getNewVersionRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 意见反馈
+ (NSURLSessionDataTask *)feedbackRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 图片上传
+ (NSURLSessionDataTask *)uploadImagesRequestWithParameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images responds:(void (^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;


// 获取最新启动图片
+ (NSURLSessionDataTask *)getLatestAppSplashImageRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

@end
