//
//  PGCSearchViewController.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchViewController.h"
#import "PGCSearchView.h"
#import "PGCProjectInfoCell.h"

@interface PGCSearchViewController () <PGCSearchViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PGCSearchView *searchView;/** 搜索框 */
@property (strong, nonatomic) UITableView *tableView;/** 搜索结果表格视图 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.title = @"搜索";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
}



#pragma mark - PGCSearchViewDelegate

- (void)searchView:(PGCSearchView *)searchView didSelectedSearchButton:(UIButton *)sender
{
    [self.view endEditing:true];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectInfoCell];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:@"" cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
}


#pragma mark - Getter

- (PGCSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[PGCSearchView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + 5, SCREEN_WIDTH, 36)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.bottom_sd + 5, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.bottom_sd) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kProjectInfoCell];
    }
    return _tableView;
}

@end
