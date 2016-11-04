//
//  PGCNavigationItem.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCNavigationItem : UIButton

// 自定义Item的图片视图
@property (strong, nonatomic) UIImageView *itemImage;
// 自定义Item的文字标签
@property (strong, nonatomic) UILabel *itemLabel;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
