//
//  PGCProvince.m
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProvince.h"

@implementation PGCProvince

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)province {
    static PGCProvince *province = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        province = [[PGCProvince alloc] init];
    });
    return province;
}

MJExtensionCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"areaArray"];
}

@end
