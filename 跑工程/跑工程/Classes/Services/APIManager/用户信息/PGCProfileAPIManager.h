//
//  PGCProfileAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCProfileAPIManager : PGCBaseAPIManager

// 修改用户信息
+ (NSURLSessionDataTask *)completeInfoRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 上传用户头像
+ (NSURLSessionDataTask *)uploadHeadImageRequestWithParameters:(NSDictionary *)parameters image:(UIImage *)image responds:(void (^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

@end
