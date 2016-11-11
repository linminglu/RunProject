//
//  PGCContactAPIManager.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBaseAPIManager.h"

@interface PGCContactAPIManager : PGCBaseAPIManager

// 添加联系人
+ (NSURLSessionDataTask *)addContactRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 获取联系人
+ (NSURLSessionDataTask *)getContactsListRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

// 删除联系人
+ (NSURLSessionDataTask *)deleteContactRequestWithParameters:(NSDictionary *)parameters responds:(void(^)(RespondsStatus status, NSString *message, id resultData))respondsBlock;

@end
