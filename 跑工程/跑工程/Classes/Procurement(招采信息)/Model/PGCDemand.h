//
//  PGCDemand.h
//  跑工程
//
//  Created by leco on 2016/11/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contacts.h"
#import "Images.h"
#import "Files.h"

// 需求模型
@interface PGCDemand : NSObject

@property (assign, nonatomic) int id;                   /** id */
@property (assign, nonatomic) int user_id;              /** 用户id */
@property (assign, nonatomic) int type_id;              /** type_id */
@property (copy, nonatomic) NSString *title;            /** 标题 */
@property (copy, nonatomic) NSString *keyword;          /** 关键字 */
@property (copy, nonatomic) NSString *desc;             /** 描述信息 */
@property (copy, nonatomic) NSString *start_time;       /** 开始时间 */
@property (copy, nonatomic) NSString *end_time;         /** 结束时间 */
@property (assign, nonatomic) int city_id;              /** city_id */
@property (copy, nonatomic) NSString *address;          /** 地址 */
@property (assign, nonatomic) int sequence;             /** sequence */
@property (assign, nonatomic) int status;               /** 状态  */
@property (copy, nonatomic) NSString *create_time;      /** 创建时间 */
@property (copy, nonatomic) NSString *update_time;      /** 更新时间 */

@property (assign, nonatomic) int collect_id;           /** 收藏id */
@property (copy, nonatomic) NSString *user_name;        /** 用户名 */
@property (copy, nonatomic) NSString *user_phone;       /** 用户电话 */
@property (assign, nonatomic) int province_id;          /** 省份id */
@property (copy, nonatomic) NSString *city;             /** 城市 */
@property (copy, nonatomic) NSString *province;         /** 省份 */
@property (copy, nonatomic) NSString *type_name;        /** 类型名 */
@property (copy, nonatomic) NSString *company;          /** 公司 */

@property (strong, nonatomic) NSMutableArray<Contacts *> *contacts; /** 联系人数组 */
@property (strong, nonatomic) NSMutableArray<Files *> *files;       /** 文件数组 */
@property (strong, nonatomic) NSMutableArray<Images *> *images;     /** 图片数组 */

@end
