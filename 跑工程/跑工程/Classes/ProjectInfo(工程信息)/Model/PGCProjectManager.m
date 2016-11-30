//
//  PGCProjectManager.m
//  跑工程
//
//  Created by leco on 2016/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectManager.h"

@implementation PGCProjectManager

+ (instancetype)manager {
    static PGCProjectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PGCProjectManager alloc] init];
    });
    return manager;
}

- (NSMutableArray *)setProjectType
{
    NSMutableArray *results = [NSMutableArray array];
    
    PGCProjectType *tempType = [[PGCProjectType alloc] init];
    tempType.type_id = -1;
    tempType.name = @"类别";
    [results insertObject:tempType atIndex:0];
    [results addObjectsFromArray:[PGCProjectManager manager].projectTypes];
    
    return results;
}

- (NSMutableArray *)setProjectProgress
{
    NSMutableArray *results = [NSMutableArray array];
    
    PGCProjectProgress *tempProgress = [[PGCProjectProgress alloc] init];
    tempProgress.progress_id = -1;
    tempProgress.name = @"阶段";
    [results insertObject:tempProgress atIndex:0];
    [results addObjectsFromArray:[PGCProjectManager manager].projectProgresses];
    
    return results;
}

@end
