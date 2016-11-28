//
//  PGCSearchView.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchView.h"

#define SearchButtonWidth 60

@interface PGCSearchView ()

@property (strong, nonatomic) UITextField *searchTextField;/** 搜索输入框 */
@property (strong, nonatomic) UIButton *searchBtn;/** 搜索按钮 */

@end

@implementation PGCSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.searchBtn];
        [self addSubview:self.searchTextField];
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


- (UITextField *)searchTextField {
    if (!_searchTextField) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width - 10 - SearchButtonWidth, height)];
        _searchTextField.layer.cornerRadius = height / 2;
        _searchTextField.layer.borderColor = PGCBackColor.CGColor;
        _searchTextField.layer.borderWidth = 0.5;
        _searchTextField.layer.masksToBounds = true;
        _searchTextField.backgroundColor = PGCBackColor;
        _searchTextField.placeholder = @"请输入关键字";
        _searchTextField.textColor = RGB(102, 102, 102);
        _searchTextField.font = [UIFont systemFontOfSize:15];
        _searchTextField.tintColor = PGCTintColor;
        _searchTextField.clipsToBounds = true;
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.bounds = CGRectMake(0, 0, 30, 30);
        searchIcon.image = [UIImage imageNamed:@"搜索"];
        searchIcon.contentMode = UIViewContentModeCenter;
        _searchTextField.leftView = searchIcon;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(width - SearchButtonWidth, 0, SearchButtonWidth, height);
        _searchBtn.titleLabel.font = SetFont(16);
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_searchBtn addTarget:self action:@selector(respondsToSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}


@end
