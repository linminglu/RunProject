//
//  PGCProcurementViewController.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProcurementViewController.h"
#import "PGCSearchView.h"
#import "DOPDropDownMenu.h"
#import "PGCProcurementCell.h"

#import "PGCDemandDetailVC.h"
#import "PGCDemandCollectVC.h"
#import "PGCDemandIntroduceVC.h"

#import "PGCManager.h"
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"
#import "PGCDemandAPIManager.h"
#import "PGCDemand.h"

typedef NS_ENUM(NSUInteger, BarButtonTag) {
    HeartBarTag,
    IntroduceBarTag,
};

@interface PGCProcurementViewController () <UITableViewDelegate, UITableViewDataSource, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, PGCSearchViewDelegate>
{
    NSArray *_areaDatas;
    NSArray *_typeDatas;
    NSArray *_timeDatas;
    
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
    
    BOOL _isSearching; /** 记录当前搜索状态 */
}

@property (strong, nonatomic) PGCSearchView *searchView;/** 搜索框 */
@property (strong, nonatomic) DOPDropDownMenu *menu;/** 下拉菜单 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 参数 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 数据源 */
@property (strong, nonatomic) NSMutableArray *searchResults;/** 搜索信息结果 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCProcurementViewController

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kProcurementInfoData object:nil];
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
    self.title = @"招采信息";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [self barButtonItem:CGRectMake(0, 0, 60, 40) tag:HeartBarTag title:@"我的收藏" imageName:@"我的收藏"];
    self.navigationItem.rightBarButtonItem= [self barButtonItem:CGRectMake(0, 0, 60, 40) tag:IntroduceBarTag title:@"我的发布" imageName:@"发布加号"];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.menu];
    [self.menu selectDefalutIndexPath];
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(loadProcurementInfoData) name:kProcurementInfoData object:nil];
}


#pragma mark - Table Refresh

- (void)loadProcurementInfoData
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (user) {
        [self.parameters setObject:@(user.user_id) forKey:@"user_id"];
        [self.parameters setObject:@"iphone" forKey:@"client_type"];
        [self.parameters setObject:manager.token.token forKey:@"token"];
    } else {
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    _page = 1;
    _pageSize = 10;
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(_pageSize) forKey:@"page_size"];
    
    // 需求信息列表
    [PGCDemandAPIManager getDemandWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            [self.dataSource removeAllObjects];
            
            for (id value in resultData[@"result"]) {
                PGCDemand *demand = [[PGCDemand alloc] init];
                [demand mj_setKeyValues:value];
                
                [self.dataSource addObject:demand];
            }
            _page += 10;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreProcurementInfoData
{
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(1) forKey:@"page_size"];
    // 需求信息列表
    [PGCDemandAPIManager getDemandWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            NSArray *resultArr = resultData[@"result"];
            if (resultArr.count > 0) {
                for (id value in resultArr) {
                    PGCDemand *demand = [[PGCDemand alloc] init];
                    [demand mj_setKeyValues:value];
                    
                    [self.dataSource addObject:demand];
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


#pragma mark - PGCSearchViewDelegate

- (void)searchView:(PGCSearchView *)searchView didSelectedSearchButton:(UIButton *)sender
{
    [self.view endEditing:true];
    
}

- (void)searchView:(PGCSearchView *)searchView textFieldDidChange:(UITextField *)textField
{
    if (!(textField.text.length > 0)) {
        _isSearching = false;
        [self.tableView reloadData];
        return;
    }
    _isSearching = true;
    
    // 获取搜索框上的文本
    NSString *text = textField.text;
    // 谓词判断，创建搜索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", text];
    // 获取搜索源
    NSMutableArray *nameSearchs = [NSMutableArray array];
    NSMutableArray *descSearchs = [NSMutableArray array];
    for (PGCDemand *demand in self.dataSource) {
        [nameSearchs addObject:demand.title];
        [descSearchs addObject:demand.desc];
    }
    // 根据谓词在搜索源中查找符合条件的对象并且赋值给searchResults;
    [self.searchResults removeAllObjects];
    
    NSArray *nameResults = [nameSearchs filteredArrayUsingPredicate:predicate];
    for (NSString *string in nameResults) {
        for (PGCDemand *demand in self.dataSource) {
            if ([string isEqualToString:demand.title]) {
                [self.searchResults addObject:demand];
            }
        }
    }
    NSArray *descResults = [descSearchs filteredArrayUsingPredicate:predicate];
    for (NSString *string in descResults) {
        for (PGCDemand *demand in self.dataSource) {
            if ([string isEqualToString:demand.desc]) {
                [self.searchResults addObject:demand];
            }
        }
    }
    [self.tableView reloadData];
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
            PGCDemandCollectVC *demandCollectVC = [[PGCDemandCollectVC alloc] init];
            [self.navigationController pushViewController:demandCollectVC animated:true];
        }
            break;
        case IntroduceBarTag:
        {
            // 推送到 我的发布 界面
            PGCDemandIntroduceVC *demandIntroduceVC = [[PGCDemandIntroduceVC alloc] init];
            [self.navigationController pushViewController:demandIntroduceVC animated:true];
        }
            break;
        default:
            break;
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isSearching ? self.searchResults.count : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProcurementCell *cell = [tableView dequeueReusableCellWithIdentifier:kProcurementCell];
    cell.demand = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCDemand *demand = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:demand keyPath:@"demand" cellClass:[PGCProcurementCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCDemandDetailVC *demandVC = [[PGCDemandDetailVC alloc] init];
    
    demandVC.demand = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    
    [self.navigationController pushViewController:demandVC animated:true];
}


#pragma mark - DOPDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
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

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
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

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
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

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
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


#pragma mark - DOPDropDownMenuDelegate

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
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
    [self loadProcurementInfoData];
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
        _searchView = [[PGCSearchView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + 5, SCREEN_WIDTH, 36)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (DOPDropDownMenu *)menu {
    if (!_menu) {
        _menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, self.searchView.bottom_sd) andHeight:40];
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
        [_tableView registerClass:[PGCProcurementCell class] forCellReuseIdentifier:kProcurementCell];
        // 设置表格视图下拉刷新和上拉加载
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadProcurementInfoData)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProcurementInfoData)];
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
