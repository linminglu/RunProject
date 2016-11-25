//
//  PGCHeadImage.h
//  跑工程
//
//  Created by leco on 2016/11/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCHeadImage : NSObject

@property (assign, nonatomic) int id;/** 图片id */
@property (copy, nonatomic) NSString *path;/** 图片存在的路径 */
@property (copy, nonatomic) NSString *http_url;/** 服务器地址 */
@property (copy, nonatomic) NSString *name;/** 文件名 */
@property (copy, nonatomic) NSString *postfix;/** 后缀 */
@property (assign, nonatomic) int width;/** 图片宽度 */
@property (assign, nonatomic) int height;/** 图片高度 */

@end
