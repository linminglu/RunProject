//
//  PGCAreaManager.m
//  跑工程
//
//  Created by leco on 2016/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAreaManager.h"

@implementation PGCAreaManager

+ (instancetype)manager {
    static PGCAreaManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PGCAreaManager alloc] init];
    });
    return manager;
}

- (NSMutableArray *)setAreaData
{
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *province in [PGCAreaManager manager].provinceDic) {
        // 构造省份可变数组
        NSMutableDictionary *provinceDic = [province mutableCopy];
        // 用于存储同一省份下的城市数组
        NSMutableArray *cityData = [NSMutableArray array];
        
        for (NSDictionary *city in [PGCAreaManager manager].cityDic) {
            if ([city[@"province_id"] intValue] == [province[@"id"] intValue]) {
                [cityData addObject:city];
            }
        }
        // 将城市数组添加到省份字典中
        [provinceDic setObject:cityData forKey:@"cities"];
        
        // 构造省份模型
        PGCProvince *province = [[PGCProvince alloc] init];
        [province mj_setKeyValues:provinceDic];
        // 将模型添加到数组中
        [results addObject:province];
    }
    
    PGCProvince *tempProvince = [[PGCProvince alloc] init];
    tempProvince.id = -1;
    tempProvince.province = @"全国";
    PGCCity *city = [[PGCCity alloc] init];
    city.id = -1;
    city.city = @"不限";
    tempProvince.cities = @[city];
    [results insertObject:tempProvince atIndex:0];
    
    return results;
}

@end
