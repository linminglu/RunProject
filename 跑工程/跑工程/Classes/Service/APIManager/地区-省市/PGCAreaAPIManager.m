//
//  PGCAreaAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAreaAPIManager.h"
#import "PGCProvince.h"
#import "PGCCity.h"

@implementation PGCAreaAPIManager

+ (NSURLSessionDataTask *)getProvincesRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kGetProvinces parameters:parameters cachePolicy:RequestReturnCacheDataThenLoad success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        [PGCProgressHUD showMessage:@"网络错误(未连接)" toView:KeyWindow afterDelayTime:1.0];
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)getCitiesRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, NSMutableArray *))respondsBlock
{    
    return [self requestPOST:kGetCities parameters:parameters cachePolicy:RequestReturnCacheDataThenLoad success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {
            NSMutableArray *cities = [NSMutableArray array];
            for (id value in resultData) {
                PGCCity *city = [[PGCCity alloc] init];
                [city mj_setKeyValues:value];
                // 将城市模型添加到数组中
                [cities addObject:city];
            }
            respondsBlock(RespondsStatusSuccess, resultMsg, cities);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [PGCProgressHUD showMessage:@"网络错误(未连接)" toView:KeyWindow afterDelayTime:1.0];
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


@end
