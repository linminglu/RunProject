//
//  PGCNavigationItem.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCNavigationItem.h"

@implementation PGCNavigationItem

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        
        [self setupSubviewsWithImage:image text:title];
    }
    return self;
}

- (void)setupSubviewsWithImage:(UIImage *)image text:(NSString *)text {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
    CGSize imageSize = image.size;
    imageView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 6)
    .widthIs(imageSize.width)
    .heightIs(imageSize.height);
    
    self.itemImage = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [self addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SetFont(11);
    label.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(imageView, 5)
    .autoHeightRatio(0);
    
    self.itemLabel = label;
}


@end
