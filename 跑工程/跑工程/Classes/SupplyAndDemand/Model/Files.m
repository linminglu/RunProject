//
//  PGCFile.m
//  跑工程
//
//  Created by leco on 2016/11/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "Files.h"

@implementation Files

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc":@"description"};
}

@end
