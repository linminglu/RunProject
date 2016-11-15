//
//  PGCSession.h
//  跑工程
//
//  Created by leco on 2016/11/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCSession : NSObject

@property (copy, nonatomic) NSString *token;/** token */
@property (assign, nonatomic) long timestamp;/** 时间戳 */
@property (assign, nonatomic) int id;/** id */
@property (copy, nonatomic) NSString *shroff_id;/** 推广人 */
@property (copy, nonatomic) NSString *name;/** 姓名 */
@property (assign, nonatomic) int sex;/** 性别 */
@property (copy, nonatomic) NSString *head_image;/** 头像 */
@property (copy, nonatomic) NSString *birthday;/** 生日 */
@property (copy, nonatomic) NSString *phone;/** 电话 */
@property (copy, nonatomic) NSString *password;/** 密码 */
@property (assign, nonatomic) int account;/** 账户 */
@property (copy, nonatomic) NSString *money;/** 钱包 */
@property (assign, nonatomic) int is_vip;/** 0:会员 1:不是会员 */
@property (copy, nonatomic) NSString *expired_time;/** 会员到期时间 */
@property (copy, nonatomic) NSString *device;/** 设备的唯一标识符 */
@property (copy, nonatomic) NSString *device_type;/** 设备 ios */
@property (copy, nonatomic) NSString *push_id;/** 信息推送 */

@end
