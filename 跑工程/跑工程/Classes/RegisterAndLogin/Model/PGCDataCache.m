//
//  PGCDataCache.m
//  跑工程
//
//  Created by leco on 2016/11/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDataCache.h"

@implementation PGCDataCache

+ (void)setCache:(id)cache forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (id)cacheForKey:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
}


@end
