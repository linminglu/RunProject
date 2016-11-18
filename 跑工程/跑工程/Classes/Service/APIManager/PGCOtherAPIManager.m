//
//  PGCOtherAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCOtherAPIManager.h"

@implementation PGCOtherAPIManager

+ (NSURLSessionDataTask *)adListRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kAdList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)getNewVersionRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kGetNewVersion parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)feedbackRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kFeedback parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)uploadImagesRequestWithParameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:true];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"正在上传...";
    
    return [self uploadRequest:kSignleImageUpload parameters:parameters images:images name:@"file" fileName:nil mimeType:@"jpg" progress:^(NSProgress *progress) {
        // 显示上传进度
        hud.progress = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud hideAnimated:true];
        
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
        [hud hideAnimated:true];
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}

@end
