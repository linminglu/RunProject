//
//  PGCIndexPath.m
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIndexPath.h"

@implementation PGCIndexPath

- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight  leftRow:(NSInteger)leftRow row:(NSInteger)row
{
    self = [super init];
    if (self) {
        _column = column;
        _leftOrRight = leftOrRight;
        _leftRow = leftRow;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row {
    PGCIndexPath *indexPath = [[self alloc] initWithColumn:col leftOrRight:leftOrRight leftRow:leftRow row:row];
    return indexPath;
}

@end
