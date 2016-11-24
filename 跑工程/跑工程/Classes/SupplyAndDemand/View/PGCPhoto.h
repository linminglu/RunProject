//
//  PGCPhoto.h
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgressBlock)(CGFloat progress);

@interface PGCPhoto : NSObject

///网络图片需要赋值的数据
@property (copy, nonatomic) NSString *url;/** 原图url */
@property (copy, nonatomic) NSString *thumbUrl;/** 高清图片url */
@property (copy, nonatomic) NSString *desc;/** 图片描述 */
@property (assign, nonatomic) CGRect scrRect; /** 原图图片的位置 */


///网络图片由url加载得到,动态加载
@property (strong, nonatomic, readonly) UIImage *image; // 大图图片
@property (assign, nonatomic) BOOL downLoad;            // 判断是否下载完成
@property (assign, nonatomic) CGRect imageViewBounds;   // 图片大小
@property (copy, nonatomic) ProgressBlock progressBlock;//下载进度

//图片宽高
+ (CGSize)displaySize:(UIImage *)image;
//根据URL返回缓存图片
+ (UIImage *)existImageWithUrl:(NSString *)urlStr;

@end
