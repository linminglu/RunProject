//
//  NSString+Size.h
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//


@interface NSString (Size)

/**
 手机号的正则表达式
 */
- (BOOL)isPhoneNumber;

/**
 时间格式转换
 */
+ (NSString *)dateString:(NSString *)oldStr;

/**
 获取文字的size
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
