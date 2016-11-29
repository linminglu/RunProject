//
//  PGCProvince.m
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProvince.h"
#import "PGCCity.h"

@implementation PGCProvince

MJExtensionCodingImplementation

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"cities":@"PGCCity"};
}

@end
