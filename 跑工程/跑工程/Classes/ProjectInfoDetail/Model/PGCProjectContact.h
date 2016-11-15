//
//  PGCProjectContact.h
//  跑工程
//
//  Created by leco on 2016/11/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 项目联系人模型
@interface PGCProjectContact : NSObject

@property (assign, nonatomic) int id;/** id */
@property (assign, nonatomic) int project_id;/** project_id */
@property (copy, nonatomic) NSString *name;/** 姓名 */
@property (assign, nonatomic) int sex;/** 性别 */
@property (copy, nonatomic) NSString *phone;/** 手机 */
@property (copy, nonatomic) NSString *telephone;/** 电话 */
@property (copy, nonatomic) NSString *position;/** 职位 */
@property (copy, nonatomic) NSString *company;/** 公司 */
@property (copy, nonatomic) NSString *address;/** 地址 */

@end
