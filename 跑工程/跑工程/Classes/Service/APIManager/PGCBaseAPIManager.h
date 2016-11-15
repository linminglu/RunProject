//
//  PGCBaseAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <YYCache/YYCache.h>
#import "PGCInterfaceConfig.h"

typedef NS_ENUM(NSInteger, RespondsStatus) {
    RespondsStatusSuccess = 0,  //请求成功
    RespondsStatusDataError,    //请求数据错误
    RespondsStatusNetworkError, //网络错误
};

typedef NS_ENUM(NSUInteger, RequestCachePolicy) {
    RequestReturnCacheDataThenLoad       = 1,      //有缓存就先返回缓存，同步请求数据
    RequestReloadIngnoringLocalCacheData = 1 << 1, //忽略缓存，重新请求
    RequestReturnCacheDataElseLoad       = 1 << 2, //有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    RequestReturnCacheDataDontLoad       = 1 << 3, //有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
};

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestType_POST = 0, //POST请求方式
    RequestType_GET,      //GET请求方式
    RequestType_UpLoad,   //POST上传
    RequestType_Download, //下载
};


typedef void(^successHandler)(NSURLSessionDataTask *task, id responseObject);

typedef void(^failureHandler)(NSURLSessionDataTask *task, NSError *error);

typedef void (^HttpProgress)(NSProgress *progress);;


@interface PGCBaseAPIManager : NSObject

@property (copy, nonatomic)  NSString *bindTag;
@property (assign, nonatomic)  NSInteger needToken;

/**
 清空缓存
 */
+ (void)removeAllCache;

/**
 获取缓存大小
 */
+ (NSInteger)getAllCacheSize;

/**
 json转字符串

 @param data
 @return
 */
+ (NSString *)jsonToString:(id)data;


#pragma mark -
#pragma mark - GET

/**
 不使用缓存 的GET请求

 @param urlString 请求地址
 @param parameters 请求参数
 @param success 成功的回调
 @param failure 失败的回调
 @return
 */
+ (__kindof NSURLSessionDataTask *)requestGET:(NSString *)urlString
                   parameters:(NSDictionary *)parameters
                      success:(successHandler)success
                      failure:(failureHandler)failure;


/**
 自定义 HTTPRequestCachePolicy 的GET请求

 @param urlString 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param success 成功的回调
 @param failure 失败的回调
 @return
 */
+ (__kindof NSURLSessionDataTask *)requestGET:(NSString *)urlString
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(RequestCachePolicy)cachePolicy
                      success:(successHandler)success
                      failure:(failureHandler)failure;



#pragma mark -
#pragma mark - POST

/**
 不使用缓存 的POST请求

 @param urlString 请求地址
 @param parameters 请求参数
 @param success 成功的回调
 @param failure 失败的回调
 @return
 */
+ (__kindof NSURLSessionDataTask *)requestPOST:(NSString *)urlString
                                    parameters:(NSDictionary *)parameters
                                       success:(successHandler)success
                                       failure:(failureHandler)failure;


/**
 自定义 HKHTTPRequestCachePolicy 的POST请求

 @param urlString 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param success 成功的回调
 @param failure 失败的回调
 @return
 */
+ (__kindof NSURLSessionDataTask *)requestPOST:(NSString *)urlString
                                    parameters:(NSDictionary *)parameters
                                   cachePolicy:(RequestCachePolicy)cachePolicy
                                       success:(successHandler)success
                                       failure:(failureHandler)failure;




/**
 *  上传图片文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionDataTask *)uploadRequest:(NSString *)urlString
                                      parameters:(NSDictionary *)parameters
                                           image:(UIImage *)image
                                            name:(NSString *)name
                                        fileName:(NSString *)fileName
                                        mimeType:(NSString *)mimeType
                                        progress:(HttpProgress)progress
                                         success:(successHandler)success
                                         failure:(failureHandler)failure;
@end
