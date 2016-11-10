//
//  PGCHttpService.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "PGCInterfaceConfig.h"

//基础网络请求 其他的请求统一由此类发出

typedef NS_ENUM(NSUInteger, HTTP_REQUEST_METHOD) {
    HTTP_REQUEST_METHOD_GET = 0,
    HTTP_REQUEST_METHOD_HEAD,
    HTTP_REQUEST_METHOD_POST,
    HTTP_REQUEST_METHOD_PUT,
    HTTP_REQUEST_METHOD_PATCH,
    HTTP_REQUEST_METHOD_DELETE,
};

typedef void(^completionHandler)(id data,NSError *error);

@interface PGCHttpService : NSObject

+ (PGCHttpService *)service;

//普通请求
- (NSURLSessionDataTask *)sendRequestWithHttpMethod:(HTTP_REQUEST_METHOD)method URLPath:(NSString *)pathStr parameters:(id)parameters completionHandler:(completionHandler)completionHandler;

@end
