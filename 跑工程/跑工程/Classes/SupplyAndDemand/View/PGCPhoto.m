//
//  PGCPhoto.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCPhoto.h"

@implementation PGCPhoto

#pragma mark - 截图

- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (UIImage *)image
{
    UIImage *urlImage = [PGCPhoto existImageWithUrl:self.url];
    
    if (urlImage) {
        if (self.progressBlock) {
            self.progressBlock(1);
        }
        CGSize size = [PGCPhoto displaySize:urlImage];
        self.imageViewBounds = CGRectMake(0, 0, size.width, size.height);
        return urlImage;
        
    } else {
        __weak __typeof(self) weakself = self;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (weakself.progressBlock != nil) {
                
                CGFloat f = receivedSize*1.0 / expectedSize;
                weakself.progressBlock(f);
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            weakself.downLoad = YES;
        }];
        
        UIImage *thumbImage = [PGCPhoto existImageWithUrl:self.thumbUrl];
        self.imageViewBounds = self.scrRect;
        return thumbImage;
    }
}


+ (CGSize)displaySize:(UIImage *)image
{
    // 1.拿到图片的宽高比
    CGFloat imageW = image.size.width;
    CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = image.size.height / imageW;
    
    // 2.根据宽高比计算高度
    CGFloat width =  0;
    if (imageW < 100) {
        width = 100;
    }
    else if (imageW > ScreenW) {
        width = ScreenW;
    }
    else {
        width = image.size.width;
    }
    CGFloat height =  width * scale;
    
    return CGSizeMake(width, height);
}


//判断图片是否存在
+ (UIImage *)existImageWithUrl:(NSString *)urlStr
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *image = nil;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *key = [manager cacheKeyForURL:url];
    image = [manager.imageCache imageFromMemoryCacheForKey:key];   //先看看内存在是否存在图片
    if (!image) {
        image = [manager.imageCache imageFromDiskCacheForKey:key]; //重缓存中取出改图片
    }
    return image;
}

@end
