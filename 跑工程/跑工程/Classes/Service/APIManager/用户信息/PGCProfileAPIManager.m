//
//  PGCProfileAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProfileAPIManager.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

@implementation PGCProfileAPIManager

+ (NSURLSessionDataTask *)completeInfoRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kUserCompleteInfo parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            
            //构造token模型
            PGCToken *token = [[PGCToken alloc] init];
            [token mj_setKeyValues:resultData];
            
            // 保存用户登录信息
            [PGCTokenManager tokenManager].token = token;
            [[PGCTokenManager tokenManager] saveAuthorizeData];
            
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
