//
//  PGCSearchView.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchView.h"

@interface PGCSearchView ()

@property (strong, nonatomic) UIView *backView;/** 背景视图 */

@end

@implementation PGCSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self addSubview:self.backView];
    }
    return self;
}


#pragma mark - Event

- (void)respondsToSearchBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:didSelectedSearchButton:)]) {
        [self.delegate searchView:self didSelectedSearchButton:sender];
    };
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:textFieldDidChange:)]) {
        [self.delegate searchView:self textFieldDidChange:textField];
    };
}


#pragma mark - Getter

- (UIView *)backView {
    if (!_backView) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, width - 20, height)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = height / 2;
        _backView.layer.borderColor = PGCBackColor.CGColor;
        _backView.layer.borderWidth = 0.5;
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"搜索"];
        searchIcon.contentMode = UIViewContentModeCenter;
        
        UITextField *searchTextField = [[UITextField alloc] init];
        searchTextField.borderStyle = UITextBorderStyleNone;
        searchTextField.placeholder = @"请输入关键字";
        searchTextField.textColor = RGB(102, 102, 102);
        searchTextField.font = SetFont(16);
        [searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIButton *searchBtn = [[UIButton alloc] init];
        [searchBtn.titleLabel setFont:SetFont(16)];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [searchBtn addTarget:self action:@selector(respondsToSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_backView addSubview:searchIcon];
        [_backView addSubview:searchTextField];
        [_backView addSubview:searchBtn];
        
        searchIcon.sd_layout
        .centerYEqualToView(_backView)
        .leftSpaceToView(_backView, 5)
        .widthIs(30)
        .heightIs(30);
        
        searchBtn.sd_layout
        .centerYEqualToView(searchIcon)
        .rightSpaceToView(_backView, 5)
        .widthIs(50)
        .heightIs(30);
        
        searchTextField.sd_layout
        .centerYEqualToView(searchIcon)
        .leftSpaceToView(searchIcon, 0)
        .rightSpaceToView(searchBtn, 0)
        .heightRatioToView(_backView, 1.0);
    }
    return _backView;
}


@end
