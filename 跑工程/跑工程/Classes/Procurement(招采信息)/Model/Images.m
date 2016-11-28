//
//  Images.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "Images.h"

@implementation Images

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"imageDec":@"description"};
}

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"isPublish"];
}


@end
