//
//  PGCContactsController.m
//  跑工程
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactsController.h"
#import "PGCContactsCell.h"
#import "PGCContactInfoController.h"
#import "PGCContactAPIManager.h"
#import "BMChineseSort.h"
#import "PGCContact.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

@interface PGCContactsController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
{
    BOOL _isSearching; /** 记录当前搜索状态 */
}

#pragma mark - 控件
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<PGCContact *> *dataSource;/** 初始数据源 */
@property (strong, nonatomic) NSArray *indexArray;/** 排序后的出现过的拼音首字母数组 */
@property (strong, nonatomic) NSArray *letterArray;/** 排序好的结果数组 */
@property (strong, nonatomic) NSMutableArray *searchDataSource;/** 搜索条数据源 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end


@implementation PGCContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = RGB(250, 117, 10);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self initializeDataSource];
    [self initializeUserInterface];
}


- (void)initializeDataSource
{
    _isSearching = false;
    
    [[PGCTokenManager tokenManager] readAuthorizeData];
    PGCUserInfo *user = [PGCTokenManager tokenManager].token.user;
    
    NSDictionary *params = @{@"user_id":@(user.id), @"client_type":@"iphone", @"token":[PGCTokenManager tokenManager].token.token};
    
    [PGCContactAPIManager getContactsListRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        if (status == RespondsStatusSuccess) {
            
            for (id value in resultData) {
                PGCContact *contact = [[PGCContact alloc] init];
                [contact mj_setKeyValues:value];
                
                [self.dataSource addObject:contact];
            }
            self.indexArray = [BMChineseSort IndexWithArray:self.dataSource Key:@"name"];
            self.letterArray = [BMChineseSort sortObjectArray:self.dataSource Key:@"name"];
            
            [self.tableView reloadData];
        }
    }];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.tableView];
//    self.tableView.tableHeaderView = self.searchController.searchBar;
}


#pragma mark - UISearchResultsUpdating
// 只要搜索框在活跃状态，此方法就会被触发
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
//    return _isSearching ? 1 : self.indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.letterArray[section] count];
//    return _isSearching ? self.searchDataSource.count : [self.dataSource[_sortedKeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 正常状态下
    PGCContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactsCell];
    cell.contact = self.letterArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.indexArray[section];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCContact *contact = self.letterArray[indexPath.section][indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:contact keyPath:@"contact" cellClass:[PGCContactsCell class] contentViewWidth:SCREEN_WIDTH];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    header.backgroundColor = PGCBackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.width - 30, 30)];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = PGCTintColor;
    label.text = self.indexArray[section];
    [header addSubview:label];
    return header;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCContactInfoController *contactInfoVC = [[PGCContactInfoController alloc] init];
    contactInfoVC.contactInfo = self.letterArray[indexPath.row];
    [self.navigationController pushViewController:contactInfoVC animated:true];
}


#pragma mark - Getter

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
        _searchController.searchBar.placeholder = @"在联系人中搜索";
        // 设置搜索状态下是否隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = true;
        // 设置搜索状态下是否半透明
        _searchController.dimsBackgroundDuringPresentation = false;
        // 设置搜索状态下背景是否模糊
        _searchController.obscuresBackgroundDuringPresentation = true;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.tintColor = PGCTextColor;
    }
    return _searchController;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(239, 239, 241);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCContactsCell class] forCellReuseIdentifier:kContactsCell];
    }
    return _tableView;
}


- (NSMutableArray<PGCContact *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray *)searchDataSource {
    if (!_searchDataSource) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}


@end
