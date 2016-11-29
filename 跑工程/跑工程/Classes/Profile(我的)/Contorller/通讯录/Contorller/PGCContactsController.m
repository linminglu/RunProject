//
//  PGCContactsController.m
//  跑工程
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactsController.h"
#import "PGCSearchView.h"
#import "PGCContactsCell.h"
#import "PGCContactInfoController.h"
#import "PGCContactAPIManager.h"
#import "BMChineseSort.h"
#import "PGCContact.h"

@interface PGCContactsController () <UITableViewDelegate, UITableViewDataSource, PGCSearchViewDelegate>
{
    BOOL _isSearching; /** 记录当前搜索状态 */
}
@property (strong, nonatomic) PGCSearchView *searchView;/** 搜索视图 */
@property (strong, nonatomic) UIButton *cancelButton;/** 搜索框取消按钮 */
@property (strong, nonatomic) UITableView *tableView;/** 联系人表格视图 */
@property (strong, nonatomic) NSMutableArray<PGCContact *> *dataSource;/** 初始数据源 */
@property (strong, nonatomic) NSMutableArray *indexArray;/** 排序后的出现过的拼音首字母数组 */
@property (strong, nonatomic) NSMutableArray *letterArray;/** 排序好的结果数组 */
@property (strong, nonatomic) NSMutableArray *searchDataSource;/** 搜索数据源 */

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
    
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeUserInterface
{
    self.title = @"通讯录";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}


- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(refreshContactList) name:kContactReloadData object:nil];
}


#pragma mark - Event

- (void)cancelSearchContact:(UIButton *)sender
{
    [self.view endEditing:true];
    
    if (self.cancelButton.isSelected) {
        _isSearching = false;
        self.searchView.searchTextField.text = @"";
        [self changeStyleSearch];
        
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        } else {
            [self refreshContactList];
        }
        return;
    }
    if (self.searchView.searchTextField.text.length > 0) {
        PGCManager *manager = [PGCManager manager];
        [manager readTokenData];
        PGCUser *user = manager.token.user;
        if (!user) {
            [MBProgressHUD showError:@"请先登录" toView:self.view];
            [self.tableView.mj_header endRefreshing];
            return;
        }
        NSString *key_word = self.searchView.searchTextField.text;
        NSDictionary *params = @{@"user_id":@(user.user_id),
                                 @"client_type":@"iphone",
                                 @"token":manager.token.token,
                                 @"key_word":key_word};
        MBProgressHUD *hud = [PGCProgressHUD showProgress:@"搜索中..." toView:self.view];
        __weak typeof(self) weakSelf = self;
        [PGCContactAPIManager getContactsListRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                // 清空之前的数据
                [self.searchDataSource removeAllObjects];
                
                [self.searchDataSource addObjectsFromArray:resultData];
                _isSearching = true;
                [weakSelf changeStyleSearch];
                [self.tableView reloadData];
            }
        }];
    } else {
        [MBProgressHUD showError:@"请先输入关键字" toView:self.view];
    }
}


#pragma mark - Table Header Refresh

- (void)refreshContactList
{
    _isSearching = false;
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSDictionary *params = @{@"user_id":@(user.user_id),
                             @"client_type":@"iphone",
                             @"token":manager.token.token};
    [PGCContactAPIManager getContactsListRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            // 清空之前的数据
            [self.indexArray removeAllObjects];
            [self.letterArray removeAllObjects];
            // 添加新数据
            [self.indexArray addObjectsFromArray:[BMChineseSort IndexWithArray:resultData Key:@"name"]];
            [self.letterArray addObjectsFromArray:[BMChineseSort sortObjectArray:resultData Key:@"name"]];
            
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - PGCSearchViewDelegate

- (void)searchView:(PGCSearchView *)searchView textFieldDidReturn:(UITextField *)textField
{
    [self cancelSearchContact:nil];
}

//- (void)searchView:(PGCSearchView *)searchView textFieldDidChange:(UITextField *)textField
//{
//    if (!(textField.text.length > 0)) {
//        _isSearching = false;
//        [self.tableView reloadData];
//        return;
//    }
//    _isSearching = true;
//    // 获取搜索框上的文本
//    NSString *text = textField.text;
//    // 谓词判断，创建搜索条件
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", text];
//    // 获取搜索源
//    NSMutableArray *nameSearchs = [NSMutableArray array];
//    for (NSArray *array in self.letterArray) {
//        for (PGCContact *contact in array) {
//            [nameSearchs addObject:contact.name];
//        }
//    }
//    // 根据谓词在搜索源中查找符合条件的对象并且赋值给searchResults;
//    [self.searchDataSource removeAllObjects];
//    
//    NSArray *nameResults = [nameSearchs filteredArrayUsingPredicate:predicate];
//    for (NSString *string in nameResults) {
//        for (NSArray *array in self.letterArray) {
//            for (PGCContact *contact in array) {
//                if ([string isEqualToString:contact.name]) {
//                    [self.searchDataSource addObject:contact];
//                }
//            }
//        }
//    }
//    [self.tableView reloadData];
//
//}



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
    [self.navigationController pushViewController:contactInfoVC animated:true];
}

- (void)changeStyleSearch
{
    if (_isSearching) {
        self.cancelButton.selected = true;
        [self.cancelButton setTitle:nil forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"delete_y"] forState:UIControlStateNormal];
    } else {
        self.cancelButton.selected = false;
        self.cancelButton.titleLabel.font = SetFont(16);
        [self.cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [self.cancelButton setImage:nil forState:UIControlStateNormal];
    }
}


#pragma mark - Getter

- (PGCSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[PGCSearchView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + 5, SCREEN_WIDTH, 35)];
        _searchView.showSearchBtn = false;
        _searchView.delegate = self;
        [_searchView addSubview:self.cancelButton];
        [self changeStyleSearch];
    }
    return _searchView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(self.searchView.right_sd - 60, 0, 60, self.searchView.height_sd);
        [_cancelButton addTarget:self action:@selector(cancelSearchContact:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.bottom_sd + 5, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
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
