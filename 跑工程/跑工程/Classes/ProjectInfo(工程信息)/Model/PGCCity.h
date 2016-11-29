//
//  PGCCity.h
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//城市模型
@interface PGCCity : NSObject

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int province_id;//所属省份
@property (copy, nonatomic) NSString *city;//城市名称
@property (copy, nonatomic) NSString *pinyin;//名称拼音
@property (copy, nonatomic) NSString *code;//编号
@property (assign, nonatomic) double lat;//维度
@property (assign, nonatomic) double lng;//经度
@property (copy, nonatomic) NSString *short_name;//简称

@property (assign, nonatomic) int sequence;/** 序号 */
@property (copy, nonatomic) NSString *status;/** 状态 */
@property (copy, nonatomic) NSString *create_time;/** 创建时间 */
@property (copy, nonatomic) NSString *update_time;/** 更新时间 */

@end
