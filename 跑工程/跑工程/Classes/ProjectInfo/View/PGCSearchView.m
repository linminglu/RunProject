//
//  PGCSearchView.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchView.h"

@interface PGCSearchView () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *searchBtn;/**搜索按钮*/
@property (nonatomic,strong) UITextField *searchTextField;/**输入框*/

@end

@implementation PGCSearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)initUI
{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = self.bounds.size.height/2;
    [self addSubview:backView];
    
    [backView addSubview:self.searchBtn];
    [backView addSubview:self.searchTextField];
}


- (void)createSearchBar
{
    //创建searBar，设置其属性
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.bounds = CGRectMake(0, 0, 300, 30);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"透明"]];
    self.searchBar.backgroundImage = imageView.image;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.searchBar.layer.cornerRadius = 20;
    self.searchBar.placeholder = @"在联系人中搜索";
    self.searchBar.delegate = self;
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 85, 40, 20)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_cancelBtn setHidden:true];
    [_cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
}



//取消搜索
- (void) cancelSearch
{
    [_cancelBtn setHidden:true];
    self.searchBar.frame = CGRectMake(10, 75, SCREEN_WIDTH - 20, 40);
    self.searchBar.text = nil;
    self.searchBar.userActivity = false;
    
}



#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    //    当开始输入文字时搜索条变短，右边出现取消按钮
    self.searchBar.frame = CGRectMake(10, 75, SCREEN_WIDTH - 70, 40);
    if (searchText.length > 0) {
        [_cancelBtn setHidden:false];
    }
    //    匹配搜索内容
    //        self.searchDataSource = [NSMutableArray array];
    //        for (NSArray *array in self.dataSource) {
    //            for (NSString *name in array) {
    //                NSString *nameStr = [name substringWithRange:NSMakeRange(0,1)];
    //                if ([searchText isEqualToString:name] || [searchText isEqualToString:nameStr]) {
    //                    [self.searchDataSource addObject:name];
    //                }
    //                每次匹配后都刷新界面
    //                [self.tableView reloadData];
    //            }
    //        }
    //    }
    
    //    当没有输入文字时搜索条回归正常
    //    if (searchText.length == 0) {
    //        self.searchBar.frame = CGRectMake(10, 75, SCREEN_WIDTH - 20, 40);
    //        [_cancelBtn setHidden:YES];
    //        self.searchDataSource = nil;
    //        [self.tableView reloadData];
    //    }
}


#pragma mark - Event

-(void)respondsToSearchBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:didSelectedSearchButton:)]) {
        [self.delegate searchView:self didSelectedSearchButton:sender];
    };
}


#pragma mark - Getter
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(respondsToSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchBtn;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.size_sd = CGSizeMake(300, 30);
        _searchTextField.placeholder = @"请输入关键字";
        _searchTextField.background = [UIImage imageNamed:@"搜索框背景"];
        _searchTextField.font = SetFont(15);
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"搜索"];
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.size = CGSizeMake(30, 30);
        
        _searchTextField.leftView = searchIcon;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTextField;
}







@end
