//
//  PGCProjectProgress.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectProgress.h"

@implementation PGCProjectProgress

static PGCProjectProgress *progress;

+ (instancetype)projectProgress {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progress = [[PGCProjectProgress alloc] init];
    });
    return progress;
}

MJExtensionCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"progressArray"];
}

@end
