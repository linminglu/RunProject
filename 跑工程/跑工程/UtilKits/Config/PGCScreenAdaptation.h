//
//  PGCScreenAdaptation.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#ifndef PGCScreenAdaptation_h
#define PGCScreenAdaptation_h

#import <UIKit/UIKit.h>

/**
 将IPHONE_WIDTH改为对应设计图的宽度
 在使用的时候直接使用PGCAdaptationFrame函数
 若通过CGRectGetMaxX(firstView.frame)获取视图坐标
 需判断该视图是否已做过适配，若做过适配需要除以PGCAdaptationWidth()
 还原为其设计图上的坐标位置
 */
// 以 iPhone6s 为标准
#define IPHONE_WIDTH 375

static inline CGFloat PGCAdaptationWidth() {
    return SCREEN_WIDTH / IPHONE_WIDTH;
}

static inline CGSize PGCAdaptationSize(CGFloat width, CGFloat height)
{
    CGFloat newWidth = width * PGCAdaptationWidth();
    CGFloat newHeight = height * PGCAdaptationWidth();
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return newSize;
}

static inline CGPoint PGCAdaptationCenter(CGFloat x, CGFloat y)
{
    CGFloat newX = x * PGCAdaptationWidth();
    CGFloat newY = y * PGCAdaptationWidth();
    CGPoint point = CGPointMake(newX, newY);
    return point;
}

static inline CGRect PGCAdaptationFrame(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGFloat newX = x * PGCAdaptationWidth();
    CGFloat newY = y * PGCAdaptationWidth();
    CGFloat newWidth = width * PGCAdaptationWidth();
    CGFloat newHeight = height * PGCAdaptationWidth();
    CGRect rect = CGRectMake(newX, newY, newWidth, newHeight);
    return rect;
}

#endif /* PGCScreenAdaptation_h */
