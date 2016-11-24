//
//  PGCProjectProgress.h
//  跑工程
//
//  Created by leco on 2016/11/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 项目进度模型
@interface PGCProjectProgress : NSObject

@property (assign, nonatomic) int progress_id;
@property (copy, nonatomic) NSString *name;/** 进度名称 */
@property (copy, nonatomic) NSString *sequence;/** 序号 */
@property (copy, nonatomic) NSString *status;/** 状态 */

@end
