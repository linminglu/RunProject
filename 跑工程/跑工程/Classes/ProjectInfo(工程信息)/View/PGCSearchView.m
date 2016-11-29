//
//  PGCSearchView.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchView.h"

#define SearchButtonWidth 60

@interface PGCSearchView () <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *searchBtn;/** 搜索按钮 */

@end

@implementation PGCSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.showSearchBtn = true;
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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:textFieldDidReturn:)]) {
        [self.delegate searchView:self textFieldDidReturn:textField];
    };
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:textFieldDidChange:)]) {
        [self.delegate searchView:self textFieldDidChange:textField];
    };
    return true;
}


#pragma mark - Setter

- (void)setShowSearchBtn:(BOOL)showSearchBtn
{
    _showSearchBtn = showSearchBtn;
    
    if (showSearchBtn) {
        [self addSubview:self.searchBtn];
    } else {
        [self.searchBtn removeFromSuperview];
    }
}

#pragma mark - Getter

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width - 10 - SearchButtonWidth, height)];
        searchTextField.layer.cornerRadius = height / 2;
        searchTextField.layer.borderColor = PGCBackColor.CGColor;
        searchTextField.layer.borderWidth = 0.5;
        searchTextField.layer.masksToBounds = true;
        searchTextField.backgroundColor = PGCBackColor;
        searchTextField.placeholder = @"请输入关键字";
        searchTextField.textColor = RGB(102, 102, 102);
        searchTextField.font = [UIFont systemFontOfSize:15];
        searchTextField.tintColor = PGCTintColor;
        searchTextField.returnKeyType = UIReturnKeySearch;
        searchTextField.enablesReturnKeyAutomatically = true;
        searchTextField.delegate = self;
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.bounds = CGRectMake(0, 0, 30, 30);
        searchIcon.image = [UIImage imageNamed:@"搜索"];
        searchIcon.contentMode = UIViewContentModeCenter;
        searchTextField.leftView = searchIcon;
        searchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        _searchTextField = searchTextField;
    }
    return _searchTextField;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(width - SearchButtonWidth, 0, SearchButtonWidth, height);
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(respondsToSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}


@end
