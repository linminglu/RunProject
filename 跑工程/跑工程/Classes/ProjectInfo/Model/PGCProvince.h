//
//  PGCProvince.h
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PGCCity;

//省份模型
@interface PGCProvince : NSObject

@property (assign, nonatomic) int id;
@property (copy, nonatomic) NSString *province;//省的名称
@property (copy, nonatomic) NSString *pinyin;//名称拼音
@property (copy, nonatomic) NSString *code;//编号
@property (assign, nonatomic) double lat;//维度
@property (assign, nonatomic) double lng;//经度
@property (copy, nonatomic) NSString *short_name;//简称
@property (copy, nonatomic) NSArray *cities;/** 城市数组 */

@end
