//
//  PGCSearchView.h
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCSearchView;

@protocol PGCSearchViewDelegate <NSObject>

@optional
/**
 点击搜索按钮

 @param searchView
 @param sender
 */
- (void)searchView:(PGCSearchView *)searchView didSelectedSearchButton:(UIButton *)sender;
/**
 点击键盘的搜索按钮

 @param searchView
 @param textField
 */
- (void)searchView:(PGCSearchView *)searchView textFieldDidReturn:(UITextField *)textField;
/**
 搜索框文本的值改变

 @param searchView
 @param textField 
 */
- (void)searchView:(PGCSearchView *)searchView textFieldDidChange:(UITextField *)textField;

@end

@interface PGCSearchView : UIView

@property (weak, nonatomic) id <PGCSearchViewDelegate> delegate;
@property (weak, nonatomic) UITextField *searchTextField;/** 搜索输入框 */
@property (assign, nonatomic) BOOL showSearchBtn;/** 是否显示搜索按钮 默认为true */

@end
