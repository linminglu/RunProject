//
//  PGCSupplyInfoViewController.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyInfoViewController.h"
#import "PGCSearchView.h"
#import "DropDownMenu.h"
#import "PGCSupplyInfoCell.h"

#import "PGCSupplyDetailVC.h"
#import "PGCSupplyCollectVC.h"
#import "PGCSupplyIntroduceVC.h"

#import "PGCManager.h"
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"
#import "PGCSupplyAPIManager.h"
#import "PGCSupply.h"

typedef NS_ENUM(NSUInteger, BarButtonTag) {
    HeartBarTag,
    IntroduceBarTag,
};

@interface PGCSupplyInfoViewController () <UITableViewDelegate, UITableViewDataSource, DropDownMenuDataSource, DropDownMenuDelegate, PGCSearchViewDelegate>
{
    NSArray *_areaDatas;
    NSArray *_typeDatas;
    NSArray *_timeDatas;
    
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
    
    BOOL _isSearching; /** 记录当前搜索状态 */
}

@property (strong, nonatomic) PGCSearchView *searchView;/** 搜索框 */
@property (strong, nonatomic) UIButton *cancelButton;/** 搜索框取消按钮 */
@property (strong, nonatomic) DropDownMenu *menu;/** 下拉菜单 */
@property (strong, nonatomic) UIButton *collectBtn;/** 我的收藏按钮 */
@property (strong, nonatomic) UIButton *introduceBtn;/** 我的发布按钮 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 参数 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 数据源 */
@property (strong, nonatomic) NSMutableArray *searchResults;/** 搜索信息结果 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCSupplyInfoViewController

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kSupplyInfoData object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeDataSource
{
    _isSearching = false;
    
    _areaDatas = [[PGCAreaManager manager] setAreaData];
    _typeDatas = [[PGCMaterialServiceTypes materialServiceTypes] setMaterialTypes];
    _timeDatas = @[@"时间", @"一天", @"三天", @"一周", @"一个月", @"三个月", @"半年", @"一年"];
}

- (void)initializeUserInterface
{
    self.title = @"供应信息";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *heart = [self barButtonItem:CGRectMake(0, 0, 45, 40)
                                             tag:HeartBarTag
                                           title:@"我的收藏"
                                       imageName:@"我的收藏"];
    UIBarButtonItem *add = [self barButtonItem:CGRectMake(0, 0, 45, 40)
                                           tag:IntroduceBarTag
                                         title:@"我的发布"
                                     imageName:@"发布加号"];
    self.navigationItem.rightBarButtonItems = @[add, heart];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.menu];
    [self.menu selectDefalutIndexPath];
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(loadSupplyInfoData) name:kSupplyInfoData object:nil];
}


#pragma mark - Table Refresh

- (void)loadSupplyInfoData
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (user) {
        [self.parameters setObject:@(user.user_id) forKey:@"user_id"];
    }
    
    _page = 1;
    _pageSize = 10;
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(_pageSize) forKey:@"page_size"];
    [self.parameters setObject:@"" forKey:@"key_word"];
    
    // 供应信息列表
    [PGCSupplyAPIManager getSupplyWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            [self.dataSource removeAllObjects];
            
            for (id value in resultData[@"result"]) {
                PGCSupply *supply = [[PGCSupply alloc] init];
                [supply mj_setKeyValues:value];
                
                [self.dataSource addObject:supply];
            }
            _page += 10;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreSupplyInfoData
{
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(1) forKey:@"page_size"];
    // 供应信息列表
    [PGCSupplyAPIManager getSupplyWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            NSArray *resultArr = resultData[@"result"];
            if (resultArr.count > 0) {
                for (id value in resultArr) {
                    PGCSupply *supply = [[PGCSupply alloc] init];
                    [supply mj_setKeyValues:value];
                    
                    [self.dataSource addObject:supply];
                }
                [self.tableView.mj_footer endRefreshing];
                _page++;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}


#pragma mark - Event

- (void)barButtonItemEvent:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        return;
    }
    switch (sender.tag) {
        case HeartBarTag:
        {
            // 推送到 我的收藏 界面
            PGCSupplyCollectVC *supplyCollectVC = [[PGCSupplyCollectVC alloc] init];;
            
            [self.navigationController pushViewController:supplyCollectVC animated:true];
        }
            break;
        case IntroduceBarTag:
        {
            // 推送到 我的发布 界面
            PGCSupplyIntroduceVC *supplyIntroduceVC = [[PGCSupplyIntroduceVC alloc] init];;
            
            [self.navigationController pushViewController:supplyIntroduceVC animated:true];
        }
            break;
        default:
            break;
    }
}


- (void)cancelSearchSupply:(UIButton *)sender
{
    [self.view endEditing:true];
    
    if (self.cancelButton.isSelected) {
        _isSearching = false;
        self.searchView.searchTextField.text = @"";
        [self changeStyleSearch];
        
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        } else {
            [self loadSupplyInfoData];
        }
        return;
    }
    if (self.searchView.searchTextField.text.length > 0) {
        
        _page = 1;
        _pageSize = 10;
        NSString *key_word = self.searchView.searchTextField.text;
        [self.parameters setObject:@(_page) forKey:@"page"];
        [self.parameters setObject:@(_pageSize) forKey:@"page_size"];
        [self.parameters setObject:key_word forKey:@"key_word"];
        
        MBProgressHUD *hud = [PGCProgressHUD showProgress:@"搜索中..." toView:self.view];
        __weak typeof(self) weakSelf = self;
        [PGCSupplyAPIManager getSupplyWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                // 清空之前的数据
                [self.searchResults removeAllObjects];
                // 添加新数据
                for (id value in resultData[@"result"]) {
                    PGCSupply *supply = [[PGCSupply alloc] init];
                    [supply mj_setKeyValues:value];
                    
                    [self.searchResults addObject:supply];
                }
                _page += 10;
                _isSearching = true;
                [weakSelf changeStyleSearch];
                [self.tableView reloadData];
            }
        }];
    } else {
        [MBProgressHUD showError:@"请先输入关键字" toView:self.view];
    }
}


#pragma mark - PGCSearchViewDelegate

- (void)searchView:(PGCSearchView *)searchView textFieldDidReturn:(UITextField *)textField
{    
    [self cancelSearchSupply:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isSearching ? self.searchResults.count : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyInfoCell];
    cell.supply = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupply *supply = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:supply keyPath:@"supply" cellClass:[PGCSupplyInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        return;
    }
    PGCSupplyDetailVC *supplyVC = [[PGCSupplyDetailVC alloc] init];
    supplyVC.supply = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];    
    [self.navigationController pushViewController:supplyVC animated:true];
}


#pragma mark - DropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(DropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    switch (column) {
        case 0: return _areaDatas.count;
            break;
        case 1: return _typeDatas.count;
            break;
        default: return _timeDatas.count;
            break;
    }
}

- (NSString *)menu:(DropDownMenu *)menu titleForRowAtIndexPath:(IndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
        {
            PGCProvince *province = _areaDatas[indexPath.row];
            return province.province;
        }
            break;
        case 1:
        {
            PGCMaterialServiceTypes *type = _typeDatas[indexPath.row];
            return type.name;
        }
            break;
        default: return _timeDatas[indexPath.row];
            break;
    }
}

// new datasource

- (NSInteger)menu:(DropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    switch (column) {
        case 0:
        {
            PGCProvince *province = _areaDatas[row];
            return province.cities.count;
        }
            break;
        case 1:
        {
            PGCMaterialServiceTypes *types = _typeDatas[row];
            return types.secondArray.count;
        }
            break;
        default: return 0;
            break;
    }
}

- (NSString *)menu:(DropDownMenu *)menu titleForItemsInRowAtIndexPath:(IndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
        {
            PGCProvince *province = _areaDatas[indexPath.row];
            PGCCity *city = province.cities[indexPath.item];
            return city.city;
        }
            break;
        case 1:
        {
            PGCMaterialServiceTypes *types = _typeDatas[indexPath.row];
            PGCMaterialServiceTypes *secondType = types.secondArray[indexPath.item];
            return secondType.name;
        }
            break;
        default: return nil;
            break;
    }
}


#pragma mark - DropDownMenuDelegate

- (void)menu:(DropDownMenu *)menu didSelectRowAtIndexPath:(IndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
        {
            if (indexPath.item > 0) {
                PGCProvince *province = _areaDatas[indexPath.row];
                PGCCity *city = province.cities[indexPath.item];
                [self.parameters setObject:@(city.id) forKey:@"city_id"];
                
            } else {
                PGCProvince *province = _areaDatas[indexPath.row];
                [self.parameters setObject:@(province.id) forKey:@"province_id"];
            }
        }
            break;
        case 1:
        {
            if (indexPath.item > 0) {
                PGCMaterialServiceTypes *type = _typeDatas[indexPath.row];
                PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.item];
                [self.parameters setObject:@(secondType.id) forKey:@"type_id"];
                
            } else {
                PGCMaterialServiceTypes *type = _typeDatas[indexPath.row];                
                [self.parameters setObject:@(type.id) forKey:@"type_id"];
            }
        }
            break;
        default:
        {
            NSArray *array = @[@0, @1, @3, @7 ,@30, @90, @180, @365];
            [self.parameters setObject:array[indexPath.row] forKey:@"days"];
        }
            break;
    }
    [self loadSupplyInfoData];
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

- (UIBarButtonItem *)barButtonItem:(CGRect)bounds
                               tag:(NSUInteger)tag
                             title:(NSString *)title
                         imageName:(NSString *)imageName
{
    UIButton *button = [[UIButton alloc] init];
    button.bounds = bounds;
    button.tag = tag;
    [button.titleLabel setFont:SetFont(11)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(barButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:5];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

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
        [_cancelButton addTarget:self action:@selector(cancelSearchSupply:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


- (DropDownMenu *)menu {
    if (!_menu) {
        _menu = [[DropDownMenu alloc] initWithOrigin:CGPointMake(0, self.searchView.bottom_sd + 5) andHeight:40];
        _menu.backgroundColor = [UIColor whiteColor];
        _menu.dataSource = self;
        _menu.delegate = self;
    }
    return _menu;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.menu.bottom_sd, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - self.menu.bottom_sd) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PGCSupplyInfoCell class] forCellReuseIdentifier:kSupplyInfoCell];
        // 设置表格视图下拉刷新和上拉加载
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSupplyInfoData)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSupplyInfoData)];
        footer.ignoredScrollViewContentInsetBottom = 0;
        _tableView.mj_footer = footer;
    }
    return _tableView;
}


- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

@end
