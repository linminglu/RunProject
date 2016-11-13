//
//  PGCProjectProgress.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectProgress.h"

@implementation PGCProjectProgress

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)projectProgress {
    static PGCProjectProgress *progress = nil;
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
