//
//  PGCDataCache.h
//  跑工程
//
//  Created by leco on 2016/11/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCDataCache : NSObject

+ (void)setCache:(id)data forKey:(NSString *)key;

+ (id)cacheForKey:(NSString *)key;

@end
