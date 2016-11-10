//
//  PGCMaterialServiceTypes.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 类别模型
@interface PGCMaterialServiceTypes : NSObject

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int parent_id;//父级
@property (copy, nonatomic) NSString *name;//名称
@property (assign, nonatomic) int sequence;//序号
@property (strong, nonatomic) NSMutableArray<PGCMaterialServiceTypes *> *secondArray;//二级类别数组
@property (copy, nonatomic) NSArray *typeArray;//类别数组

+ (instancetype)materialServiceTypes;

@end
