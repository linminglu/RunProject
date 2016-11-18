//
//  PGCDemand.h
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contacts.h"
#import "Images.h"
#import "Files.h"
#import "Types.h"

// 供应模型
@interface PGCSupply : NSObject

@property (assign, nonatomic) int id;               /** id */
@property (assign, nonatomic) int collect_id;       /** 收藏id */
@property (assign, nonatomic) int user_id;          /** 用户id */
@property (copy, nonatomic) NSString *user_name;    /** 用户名 */
@property (copy, nonatomic) NSString *user_phone;   /** 用户电话 */
@property (assign, nonatomic) int province_id;      /** 省份id */
@property (copy, nonatomic) NSString *province;     /** 省份 */
@property (assign, nonatomic) int city_id;          /** city_id */
@property (copy, nonatomic) NSString *city;         /** 城市 */
@property (assign, nonatomic) int type_id;          /** type_id */
@property (copy, nonatomic) NSString *keyword;      /** 关键字 */
@property (copy, nonatomic) NSString *title;        /** 标题 */
@property (copy, nonatomic) NSString *company;      /** 公司 */
@property (copy, nonatomic) NSString *address;      /** 地址 */
@property (copy, nonatomic) NSString *desc;         /** 描述信息 */
@property (assign, nonatomic) int sequence;         /** sequence */
@property (copy, nonatomic) NSString *start_time;   /** 开始时间 */
@property (copy, nonatomic) NSString *end_time;     /** 结束时间 */
@property (strong, nonatomic) NSMutableArray<Types *> *types;       /** 类别数组 */
@property (strong, nonatomic) NSMutableArray<Contacts *> *contacts; /** 联系人数组 */
@property (strong, nonatomic) NSMutableArray<Files *> *files;       /** 文件数组 */
@property (strong, nonatomic) NSMutableArray<Images *> *images;     /** 图片数组 */


@end
