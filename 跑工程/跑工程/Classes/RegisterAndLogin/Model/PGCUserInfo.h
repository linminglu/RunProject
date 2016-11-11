//
//  PGCUserInfo.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCUserInfo : NSObject

@property (assign, nonatomic) int id;/** id */
@property (copy, nonatomic) NSString *phone;/** 电话 */
@property (copy, nonatomic) NSString *name;/** 姓名 */
@property (copy, nonatomic) NSString *password;/** 密码 */
@property (assign, nonatomic) NSInteger id_card;/** 身份证 */
@property (copy, nonatomic) NSString *headimage;/** 头像 */
@property (assign, nonatomic) NSInteger sex;/** 性别 */
@property (copy, nonatomic) NSString *post;/** 职位 */
@property (copy, nonatomic) NSString *company;/** 公司 */
@property (assign, nonatomic) NSInteger is_vip;/** 是不是会员 */
@property (copy, nonatomic) NSString *vip_expired;/** vip 到期时间 */
@property (assign, nonatomic) int is_push;/** 是否接受推送 */
@property (copy, nonatomic) NSString *push_id;/** 信息推送 */
@property (copy, nonatomic) NSString *device_type;/** 用户设备类型 */

@end
