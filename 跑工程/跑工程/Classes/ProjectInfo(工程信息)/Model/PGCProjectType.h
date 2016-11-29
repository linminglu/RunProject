//
//  PGCProjectType.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 项目类型模型
@interface PGCProjectType : NSObject

@property (assign, nonatomic) int type_id;/** 类型id */
@property (copy, nonatomic) NSString *name;/** 类型名称 */
@property (copy, nonatomic) NSString *image;/** 图片 */
@property (copy, nonatomic) NSString *descType;/** 描述 */

@property (assign, nonatomic) int sequence;/** 序号 */
@property (copy, nonatomic) NSString *status;/** 状态 */
@property (copy, nonatomic) NSString *create_time;/** 创建时间 */
@property (copy, nonatomic) NSString *update_time;/** 更新时间 */

@end
