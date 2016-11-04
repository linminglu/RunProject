//
//  UIBarButtonItem+Extension.h
//  跑工程
//
//  Created by leco on 2016/11/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 创建一个item
 
 @param target 点击item后调用哪个对象的方法
 @param action 点击item后调用target的哪个方法
 @param image 图片
 @param highImage 高亮的图片
 @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              image:(NSString *)image
                          highImage:(NSString *)highImage;

@end
