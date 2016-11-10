//
//  PGCMaterialServiceTypes.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCMaterialServiceTypes.h"

@implementation PGCMaterialServiceTypes

static PGCMaterialServiceTypes *type;

+ (instancetype)materialServiceTypes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        type = [[PGCMaterialServiceTypes alloc] init];
    });
    return type;
}

- (NSMutableArray<PGCMaterialServiceTypes *> *)secondArray {
    if (!_secondArray) {
        _secondArray = [NSMutableArray array];
    }
    return _secondArray;
}

MJExtensionCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"typeArray"];
}

@end
