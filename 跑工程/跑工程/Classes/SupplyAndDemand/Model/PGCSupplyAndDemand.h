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

// 需求供应模型
@interface PGCSupplyAndDemand : NSObject

@property (copy, nonatomic) NSString *title;/** 标题 */
@property (copy, nonatomic) NSString *company;/** 公司 */
@property (copy, nonatomic) NSString *address;/** 地址 */
@property (assign, nonatomic) int city_id;/** 城市id */
@property (assign, nonatomic) int type_id;/** 类型id */
@property (copy, nonatomic) NSString *dec;/** 描述信息 */
@property (strong, nonatomic) NSMutableArray<Contacts *> *contacts;/** 联系人数组 */
@property (strong, nonatomic) NSMutableArray<Images *> *images;/** 图片数组 */


@end
