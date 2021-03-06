//
//  Images.h
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Images : NSObject

@property (assign, nonatomic) int id;/** 图片id */
@property (assign, nonatomic) int ref_id;/** ref_id */
@property (assign, nonatomic) int type;/** 类型 */
@property (copy, nonatomic) NSString *image;/** 图片路径 */
@property (copy, nonatomic) NSString *imageDec;/** 图片介绍 */
@property (copy, nonatomic) NSString *create_time;/** 创建时间 */
@property (copy, nonatomic) NSString *update_time;/** 更新时间 */
@property (assign, nonatomic) BOOL isPublish;/** 是否发布 */

@end
