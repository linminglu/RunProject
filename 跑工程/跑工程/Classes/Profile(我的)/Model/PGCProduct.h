//
//  PGCProduct.h
//  跑工程
//
//  Created by leco on 2016/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 会员产品模型
@interface PGCProduct : NSObject

@property (assign, nonatomic) int id;/** 产品id */
@property (copy, nonatomic) NSString *name;/** 产品名称 */
@property (copy, nonatomic) NSString *image;/** 图片路劲 */
@property (assign, nonatomic) int type;/** 类型 1：年费产品  2：季度产品，3月产品 */
@property (assign, nonatomic) int price;/** 价格 */
@property (assign, nonatomic) int productDays;/** 产品期限 */
@property (copy, nonatomic) NSString *remark;/** 备注，产品说明 */

@property (copy, nonatomic) NSString *status;/** 状态 */
@property (copy, nonatomic) NSString *create_time;/** 创建时间 */
@property (copy, nonatomic) NSString *update_time;/** 更新时间 */

@end
