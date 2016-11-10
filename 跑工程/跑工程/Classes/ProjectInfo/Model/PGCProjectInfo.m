//
//  PGCProjectInfo.m
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfo.h"

@implementation PGCProjectInfo

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc" : @"description"};
}


@end
