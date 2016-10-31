//
//  PGCProjectDetailTagView.m
//  跑工程
//
//  Created by leco on 2016/10/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectDetailTagView.h"

@interface PGCProjectDetailTagView ()

@end

@implementation PGCProjectDetailTagView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(240, 240, 240);
        
        [self addSubviewsWithTitle:title];
    }
    return self;
}

- (void)addSubviewsWithTitle:(NSString *)title {
    UIView *squareView = [[UIView alloc] init];
    squareView.backgroundColor = PGCTintColor;
    [self addSubview:squareView];
    // 开始自动布局
    squareView.sd_layout
    .leftSpaceToView(self, 15)
    .centerYEqualToView(self)
    .heightRatioToView(self, 0.4)
    .widthIs(5);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:titleLabel];
    // 开始自动布局
    titleLabel.sd_layout
    .leftSpaceToView(squareView, 10)
    .centerYEqualToView(self)
    .widthRatioToView(self, 0.8)
    .autoHeightRatio(0);
}

@end
