//
//  PGCProjectInfo.h
//  跑工程
//
//  Created by leco on 2016/11/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//项目列表模型
@interface PGCProjectInfo : NSObject

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int type_id;//用户id
@property (assign, nonatomic) int progress_is;//进度id
@property (copy, nonatomic) NSString *name;//名称
@property (copy, nonatomic) NSString *type_detail;//类型详情
@property (copy, nonatomic) NSString *keyword;//关键字
@property (copy, nonatomic) NSString *material;//所需材料
@property (copy, nonatomic) NSString *start_time;//项目开始时间
@property (copy, nonatomic) NSString *end_time;//项目结束时间
@property (copy, nonatomic) NSString *desc;//描述
@property (copy, nonatomic) NSString *html;//html路径
@property (copy, nonatomic) NSString *lat;//维度
@property (copy, nonatomic) NSString *lng;//经度
@property (copy, nonatomic) NSString *address;//地址
@property (assign, nonatomic) int city_id;//城市id
@property (copy, nonatomic) NSString *remard;//备注
@property (assign, nonatomic) int sequence;//序号
@property (copy, nonatomic) NSString *city;//城市
@property (copy, nonatomic) NSString *province;//省份
@property (copy, nonatomic) NSString *type_name;//类型名
@property (copy, nonatomic) NSString *type_image;//类型图片
@property (copy, nonatomic) NSString *type_desciption;//类型描述
@property (copy, nonatomic) NSString *progress_name;//进度名
@property (assign, nonatomic) int collect_id;//收藏id

@end
