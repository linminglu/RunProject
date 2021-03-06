//
//  LunchImage.h
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunchImage : NSObject

@property (assign, nonatomic) int image_id;/** 图片id */
@property (copy, nonatomic) NSString *image;/** 图片 */
@property (assign, nonatomic) int status;/** 状态 */
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;

@end
