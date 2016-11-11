//
//  PGCToken.m
//  跑工程
//
//  Created by leco on 2016/11/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCToken.h"

@implementation PGCToken


static PGCToken *token = nil;

+ (instancetype)token {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        token = [[PGCToken alloc] init];
    });
    return token;
}

+ (void)clearTokenInfo
{
    NSString *tokenPath = [PGCCachesPath stringByAppendingPathComponent:@"TokenInfo.plist"];
    NSError *error;
    if ([PGCFileManager removeItemAtPath:tokenPath error:&error]) {
        NSLog(@"已清除用户信息");
    } else {
        NSLog(@"erro:%@", error.userInfo);
    }
}

MJExtensionCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"isLogin"];
}

@end
