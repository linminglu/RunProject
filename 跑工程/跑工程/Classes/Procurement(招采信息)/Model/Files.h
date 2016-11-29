//
//  PGCFile.h
//  跑工程
//
//  Created by leco on 2016/11/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Files : NSObject

@property (assign, nonatomic) int id;/** 文件id */
@property (assign, nonatomic) int ref_id;/** ref_id */
@property (assign, nonatomic) int type;/** 类型 */
@property (copy, nonatomic) NSString *filename;/** 文件名 */
@property (copy, nonatomic) NSString *path;/** 文件路径 */
@property (copy, nonatomic) NSString *desc;/** 文件介绍 */

@property (copy, nonatomic) NSString *create_time;/** 创建时间 */
@property (copy, nonatomic) NSString *update_time;/** 更新时间 */

@end
