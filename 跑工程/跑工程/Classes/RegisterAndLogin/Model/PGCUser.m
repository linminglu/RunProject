//
//  PGCUser.m
//  跑工程
//
//  Created by leco on 2016/11/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCUser.h"

@implementation PGCUser

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"user_id":@"id"};
}

@end
