//
//  UIImage+Image.h
//  传智微博
//
//  Created by apple on 2016-1-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

// 加载最原始的图片，没有渲染
+ (UIImage *)imageWithOriginalName:(NSString *)imageName;

+ (UIImage *)imageWithStretchableName:(NSString *)imageName;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
