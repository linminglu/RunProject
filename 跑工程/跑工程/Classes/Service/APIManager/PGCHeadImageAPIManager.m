//
//  PGCHeadImageAPIManager.m
//  跑工程
//
//  Created by leco on 2016/11/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCHeadImageAPIManager.h"
#import "PGCBaseAPIManager.h"
#import "PGCNetworkHelper.h"

@implementation PGCHeadImageAPIManager

+ (NSURLSessionTask *)uploadHeadImageWithParameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images responds:(void(^)(RespondsStatus status, NSString *message, id resultData))responds
{
    NSString *url = [kBaseURL stringByAppendingString:kSignleImageUpload];
    
    return [PGCNetworkHelper uploadWithURL:url parameters:parameters images:images name:@"" fileName:@"" mimeType:@"" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
