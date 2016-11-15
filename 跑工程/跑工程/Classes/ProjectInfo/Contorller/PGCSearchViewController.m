//
//  PGCSearchViewController.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchViewController.h"
#import "PGCProjectInfoCell.h"
#import "PGCProjectInfo.h"
#import "PGCProjectInfoDetailVC.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

static NSString * const kSearchViewCell = @"SearchViewCell";

@interface PGCSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating>
{
    BOOL _isSearching; /** 记录当前搜索状态 */
}

@property (strong, nonatomic) UITableView *tableView;/** 搜索结果 */
@property (strong, nonatomic) UISearchController *searchController;/** 搜索控制器 */
@property (strong, nonatomic) NSMutableArray *searchResults;/** 搜索结果 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    _isSearching = false;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
//    self.tableView.tableHeaderView = self.searchController.searchBar;
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active) {
        _isSearching = false;
        [self.tableView reloadData];
        return;
    }
    _isSearching = true;
    // 获取搜索框上的文本
    NSString *text = searchController.searchBar.text;
    // 谓词判断，创建搜索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", text];
    // 获取搜索源
    NSMutableArray *nameSearchs = [NSMutableArray array];
    NSMutableArray *descSearchs = [NSMutableArray array];
    for (PGCProjectInfo *project in self.searchData) {
        [nameSearchs addObject:project.name];
        [descSearchs addObject:project.desc];
    }
    // 根据谓词在搜索源中查找符合条件的对象并且赋值给searchResults;
    [self.searchResults removeAllObjects];
    
    NSArray *nameResults = [nameSearchs filteredArrayUsingPredicate:predicate];
    for (NSString *string in nameResults) {
        for (PGCProjectInfo *project in self.searchData) {
            if ([string isEqualToString:project.name]) {
                [self.searchResults addObject:project];
            }
        }
    }
//    NSArray *descResults = [descSearchs filteredArrayUsingPredicate:predicate];
//    for (NSString *string in descResults) {
//        for (PGCProjectInfo *project in self.searchData) {
//            if ([string isEqualToString:project.desc]) {
//                [self.searchResults addObject:project];
//            }
//        }
//    }
    NSLog(@"%@", self.searchResults);
    [self.tableView reloadData];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:false];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%ld", self.searchResults.count);
    return _isSearching ? self.searchResults.count : self.searchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", self.searchResults);
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchViewCell];
    if (!cell) {
        cell = [[PGCProjectInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.project = _isSearching ? self.searchResults[indexPath.row] : self.searchData[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfo *project = _isSearching ? self.searchResults[indexPath.row] : self.searchData[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:project keyPath:@"project" cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCTokenManager *manager = [PGCTokenManager tokenManager];
    [manager readAuthorizeData];
    PGCUserInfo *user = manager.token.user;
    if (user == nil) {
        [PGCProgressHUD showMessage:@"请先登录" inView:KeyWindow];
        return;
    }
    PGCProjectInfo *projectInfo = _isSearching ? self.searchResults[indexPath.row] : self.searchData[indexPath.row];
    PGCProjectInfoDetailVC *detailVC = [[PGCProjectInfoDetailVC alloc] init];
    detailVC.projectInfoDetail = projectInfo;
    self.searchController.active = false;
    [self.navigationController pushViewController:detailVC animated:true];
}


#pragma mark - Getter

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.dimsBackgroundDuringPresentation = false;
        _searchController.hidesNavigationBarDuringPresentation = false;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        _searchController.searchBar.placeholder = @"请输入关键字";
        _searchController.searchBar.tintColor = PGCTintColor;
        _searchController.searchBar.delegate = self;
    }
    return _searchController;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kSearchViewCell];
    }
    return _tableView;
}

- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}


@end
