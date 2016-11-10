//
//  PGCProjectType.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCProjectType : NSObject

@property (assign, nonatomic) int id;
@property (copy, nonatomic) NSString *name;//进度名称
@property (copy, nonatomic) NSString *image;//图片
@property (copy, nonatomic) NSString *descType;//描述
@property (assign, nonatomic) int sequence;//序号
@property (copy, nonatomic) NSArray *projectTypes;//项目类型数组

+ (instancetype)projectType;

@end
