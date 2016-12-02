//
//  NSString+Size.h
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//


@interface NSString (Size)

/**
 普通字符串转换为十六进制
 */
+ (NSString *)stringFromHex:(NSString *)hexString;
/**
 十六进制转换为普通字符串
 */
+ (NSString *)hexFromString:(NSString *)string;
/**
 MD5加密
 */
+ (NSString *)MD5:(NSString *)str;

/**
 手机号的正则表达式
 */
+ (BOOL)valiMobile:(NSString *)mobile;

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
