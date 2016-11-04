//
//  PGCRootInfo.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCRootInfo.h"

@implementation PGCRootInfo


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return  self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"这个%@不一样",key);
}

@end
