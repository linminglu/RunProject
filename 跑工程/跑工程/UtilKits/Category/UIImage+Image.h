//
//  UIImage+Image.h
//  传智微博
//
//  Created by apple on 2016-1-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//


@interface UIImage (Image)

// 加载最原始的图片，没有渲染
+ (UIImage *)imageWithOriginalName:(NSString *)imageName;
// 加载拉伸的图片
+ (UIImage *)imageWithStretchableName:(NSString *)imageName;
// 加载颜色生成的图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
