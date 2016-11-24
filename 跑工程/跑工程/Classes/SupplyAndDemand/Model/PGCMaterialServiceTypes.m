//
//  PGCMaterialServiceTypes.m
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCMaterialServiceTypes.h"

@implementation PGCMaterialServiceTypes

+ (instancetype)materialServiceTypes {
    static PGCMaterialServiceTypes *type = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        type = [[PGCMaterialServiceTypes alloc] init];
    });
    return type;
}

- (NSMutableArray *)setMaterialTypes
{
    NSMutableArray *results = [NSMutableArray array];
    
    PGCMaterialServiceTypes *tempType = [[PGCMaterialServiceTypes alloc] init];
    tempType.id = -1;
    tempType.name = @"不限";
    [results addObjectsFromArray:[PGCMaterialServiceTypes materialServiceTypes].typeArray];
    [results insertObject:tempType atIndex:0];
    
    return results;
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
