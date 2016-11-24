//
//  PGCProjectType.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectType.h"

@implementation PGCProjectType

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"descType":@"description",
             @"type_id":@"id"};
}

@end
