//
//  PGCProjectManager.h
//  跑工程
//
//  Created by leco on 2016/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGCProjectType.h"
#import "PGCProjectProgress.h"

@interface PGCProjectManager : NSObject

@property (strong, nonatomic) NSMutableArray<PGCProjectType *> *projectTypes;/** 项目类型 */
@property (strong, nonatomic) NSMutableArray<PGCProjectProgress *> *projectProgresses;/** 项目进度 */

+ (instancetype)manager;

- (NSMutableArray *)setProjectType;

- (NSMutableArray *)setProjectProgress;

@end
