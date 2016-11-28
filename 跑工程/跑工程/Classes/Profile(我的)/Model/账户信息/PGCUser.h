//
//  PGCUser.h
//  跑工程
//
//  Created by leco on 2016/11/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户模型
@interface PGCUser : NSObject

@property (assign, nonatomic) int user_id;          /** id */
@property (copy, nonatomic) NSString *phone;        /** 电话 */
@property (copy, nonatomic) NSString *name;         /** 姓名 */
@property (copy, nonatomic) NSString *password;     /** 密码 */
@property (assign, nonatomic) int id_card;          /** 身份证 */
@property (copy, nonatomic) NSString *headimage;    /** 头像 */
@property (assign, nonatomic) int sex;              /** 性别 <0：女   1：男> */
@property (copy, nonatomic) NSString *post;         /** 职位 */
@property (copy, nonatomic) NSString *company;      /** 公司 */
@property (assign, nonatomic) int is_vip;           /** 是不是会员 <0：不是会员 1：会员> */
@property (copy, nonatomic) NSString *vip_expired; /** vip 到期时间 */
@property (copy, nonatomic) NSString *device;       /** 用户设备 */
@property (copy, nonatomic) NSString *device_type;  /** 用户设备类型 */
@property (copy, nonatomic) NSString *push_id;      /** 信息推送 */
@property (assign, nonatomic) int is_push;          /** 是否接受推送 */
@property (assign, nonatomic) int status;           /** 状态 <0:正常 1:禁用> */
@property (copy, nonatomic) NSString *create_time;  /** 创建时间 */
@property (copy, nonatomic) NSString *update_time;  /** 更新时间 */

@end
