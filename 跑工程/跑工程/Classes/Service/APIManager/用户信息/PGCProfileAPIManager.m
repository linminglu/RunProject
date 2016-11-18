//
//  PGCProfileAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProfileAPIManager.h"
#import "PGCHeadImage.h"

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
            [PGCManager manager].token = token;
            [[PGCManager manager] saveTokenData];
            
            respondsBlock(RespondsStatusSuccess, resultMsg, resultData);
        }
        else {
            respondsBlock(RespondsStatusDataError, resultMsg, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        respondsBlock(RespondsStatusNetworkError, error.localizedDescription, nil);
    }];
}


+ (NSURLSessionDataTask *)buyVipRequestWithParameters:(NSDictionary *)parameters responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    return [self requestPOST:kBuyVip parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


+ (NSURLSessionDataTask *)uploadHeadImageRequestWithParameters:(NSDictionary *)parameters image:(UIImage *)image responds:(void (^)(RespondsStatus, NSString *, id))respondsBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:true];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"正在上传头像...";
    return [self uploadRequest:kSignleImageUpload parameters:parameters images:@[image] name:@"file" fileName:@"head_img" mimeType:@"jpg" progress:^(NSProgress *progress) {
        // 显示上传进度
        hud.progress = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud hideAnimated:true];
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        NSString *resultMsg = responseObject[@"msg"];
        NSDictionary *resultData = responseObject[@"data"];
        
        if (resultCode == 200) {            
            PGCHeadImage *headImage = [[PGCHeadImage alloc] init];
            [headImage mj_setKeyValues:resultData];
            
            respondsBlock(RespondsStatusSuccess, resultMsg, headImage);
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
