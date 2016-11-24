//
//  PGCAreaManager.h
//  跑工程
//
//  Created by leco on 2016/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGCProvince.h"
#import "PGCCity.h"

// 管理省份和城市模型的工具
@interface PGCAreaManager : NSObject

@property (copy, nonatomic) NSDictionary *provinceDic;/** 省份字典 */
@property (copy, nonatomic) NSDictionary *cityDic;/** 城市字典 */

+ (instancetype)manager;

- (NSMutableArray *)setAreaData;

@end
