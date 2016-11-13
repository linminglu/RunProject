//
//  PGCProjectType.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectType.h"

@implementation PGCProjectType

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)projectType {
    static PGCProjectType *projectType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        projectType = [[PGCProjectType alloc] init];
    });
    return projectType;
}

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"descType" : @"description"};
}

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"projectTypes"];
}

@end
