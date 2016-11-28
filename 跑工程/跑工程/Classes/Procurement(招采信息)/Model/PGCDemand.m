//
//  PGCDemand.m
//  跑工程
//
//  Created by leco on 2016/11/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemand.h"

@implementation PGCDemand

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"contacts":@"Contacts",
             @"files":@"Files",
             @"images":@"Images"};
}

@end
