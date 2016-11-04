//
//  PGCRootInfo.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCRootInfo : NSObject

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
