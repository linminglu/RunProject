//
//  PGCProjectProgress.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectProgress.h"

@implementation PGCProjectProgress

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"progress_id":@"id"};
}

@end
