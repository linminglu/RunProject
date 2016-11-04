//
//  PGCSearchBar.m
//  跑工程
//
//  Created by leco on 2016/11/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchBar.h"

@implementation PGCSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:13];
        self.placeholder = @"请输入关键字";
        self.background = [UIImage imageNamed:@"搜索框背景"];
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"搜索"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}


@end
