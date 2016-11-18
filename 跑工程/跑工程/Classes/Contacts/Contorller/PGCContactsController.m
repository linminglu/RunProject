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

@interface PGCContactsController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
{
    BOOL _isSearching; /** 记录当前搜索状态 */
}

@property (strong, nonatomic) UISearchController *searchController;/** 搜索框 */
@property (strong, nonatomic) UITableView *tableView;/** 联系人表格视图 */
@property (strong, nonatomic) NSMutableArray<PGCContact *> *dataSource;/** 初始数据源 */
@property (strong, nonatomic) NSMutableArray *indexArray;/** 排序后的出现过的拼音首字母数组 */
@property (strong, nonatomic) NSMutableArray *letterArray;/** 排序好的结果数组 */
@property (strong, nonatomic) NSMutableArray *searchDataSource;/** 搜索条数据源 */

- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end


@implementation PGCContactsController

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kContactReloadData object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = PGCTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self refreshContactList];
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView.mj_header beginRefreshing];
}


- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(reloadContactData:) name:kContactReloadData object:nil];
}


- (void)reloadContactData:(NSNotification *)notifi
{
    if ([notifi.userInfo objectForKey:@"DeleteContact"]) {
        [self refreshContactList];
    }
}

#pragma mark - Table Header Refresh

- (void)refreshContactList
{
    [self.indexArray removeAllObjects];
    [self.letterArray removeAllObjects];
    
    _isSearching = false;
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        [PGCProgressHUD showMessage:@"请先登录" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSDictionary *params = @{@"user_id":@(user.user_id),
                             @"client_type":@"iphone",
                             @"token":manager.token.token};
    [PGCContactAPIManager getContactsListRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            [self.indexArray addObjectsFromArray:[BMChineseSort IndexWithArray:resultData Key:@"name"]];
            [self.letterArray addObjectsFromArray:[BMChineseSort sortObjectArray:resultData Key:@"name"]];
            
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - UISearchResultsUpdating
// 只要搜索框在活跃状态，此方法就会被触发
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
    for (NSArray *array in self.letterArray) {
        for (PGCContact *contact in array) {
            [nameSearchs addObject:contact.name];
        }
    }
    // 根据谓词在搜索源中查找符合条件的对象并且赋值给searchResults;
    [self.searchDataSource removeAllObjects];

    NSArray *nameResults = [nameSearchs filteredArrayUsingPredicate:predicate];
    for (NSString *string in nameResults) {
        for (NSArray *array in self.letterArray) {
            for (PGCContact *contact in array) {
                if ([string isEqualToString:contact.name]) {
                    [self.searchDataSource addObject:contact];
                }
            }
        }
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isSearching ? 1 : self.indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isSearching ? self.searchDataSource.count : [self.letterArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 正常状态下
    PGCContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactsCell];
    cell.contact = _isSearching ? self.searchDataSource[indexPath.row] : self.letterArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.indexArray[section];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _isSearching ? 0 : 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCContact *contact = _isSearching ? self.searchDataSource[indexPath.row] : self.letterArray[indexPath.section][indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:contact keyPath:@"contact" cellClass:[PGCContactsCell class] contentViewWidth:SCREEN_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width_sd, 30)];
    header.backgroundColor = PGCBackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.width_sd - 30, 30)];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = PGCTintColor;
    label.text = self.indexArray[section];
    [header addSubview:label];
    return header;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCContactInfoController *contactInfoVC = [[PGCContactInfoController alloc] init];
    contactInfoVC.contactInfo = _isSearching ? self.searchDataSource[indexPath.row] : self.letterArray[indexPath.section][indexPath.row];
    self.searchController.active = false;
    [self.navigationController pushViewController:contactInfoVC animated:true];
}


#pragma mark - Getter

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        // 设置搜索状态下是否隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = true;
        // 设置搜索状态下是否半透明
        _searchController.dimsBackgroundDuringPresentation = true;
        // 设置搜索状态下背景是否模糊
        _searchController.obscuresBackgroundDuringPresentation = false;
        _searchController.searchResultsUpdater = self;
        // 设置searchBar
        _searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
        _searchController.searchBar.returnKeyType = UIReturnKeySearch;
        _searchController.searchBar.placeholder = @"在联系人中搜索";
        _searchController.searchBar.barStyle = UIBarStyleDefault;
        _searchController.searchBar.translucent = true;
        _searchController.searchBar.tintColor = PGCTintColor;
        _searchController.searchBar.layer.cornerRadius = 0;
        _searchController.searchBar.layer.borderColor = PGCBackColor.CGColor;
        _searchController.searchBar.layer.borderWidth = 1.0;
        [_searchController.searchBar setBackgroundImage:[UIImage imageWithColor:PGCBackColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
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
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshContactList)];
        _tableView.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = true;
    }
    return _tableView;
}


- (NSMutableArray<PGCContact *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)letterArray {
    if (!_letterArray) {
        _letterArray = [NSMutableArray array];
    }
    return _letterArray;
}

- (NSMutableArray *)searchDataSource {
    if (!_searchDataSource) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}


@end
