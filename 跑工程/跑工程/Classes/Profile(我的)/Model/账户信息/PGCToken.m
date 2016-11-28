//
//  PGCToken.m
//  跑工程
//
//  Created by leco on 2016/11/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCToken.h"

@implementation PGCToken

MJExtensionCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _firstUseSoft = true;
    }
    return self;
}

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"firstUseSoft", @"lastSoftVersion"];
}

@end
