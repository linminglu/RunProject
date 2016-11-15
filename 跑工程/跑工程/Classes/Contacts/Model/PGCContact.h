//
//  PGCContact.h
//  跑工程
//
//  Created by leco on 2016/11/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 联系人模型
@interface PGCContact : NSObject

@property (assign, nonatomic) int id;/** 联系人id */
@property (copy, nonatomic) NSString *name;/** 姓名 */
@property (assign, nonatomic) int sex;/** 性别 */
@property (copy, nonatomic) NSString *phone;/** 手机 */
@property (copy, nonatomic) NSString *telephone;/** 座机 */
@property (copy, nonatomic) NSString *email;/** email邮箱 */
@property (copy, nonatomic) NSString *fax;/** 传真 */
@property (copy, nonatomic) NSString *position;/** 职位 */
@property (copy, nonatomic) NSString *company;/** 公司 */
@property (copy, nonatomic) NSString *address;/** 地址 */
@property (copy, nonatomic) NSString *remark;/** 备注 */

@end
