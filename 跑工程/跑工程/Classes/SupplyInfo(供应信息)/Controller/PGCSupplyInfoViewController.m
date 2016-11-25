//
//  PGCSupplyInfoViewController.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyInfoViewController.h"
#import "PGCSearchView.h"
#import "JSDropDownMenu.h"
#import "PGCProcurementCell.h"

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

@interface PGCSupplyInfoViewController () <UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource, JSDropDownMenuDelegate, PGCSearchViewDelegate>
{
    NSArray *_areaDatas;
    NSArray *_typeDatas;
    NSArray *_timeDatas;
    
    NSInteger _areaCurrentIndex;
    NSInteger _typeCurrentIndex;
    NSInteger _timeCurrentIndex;
    
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
    
    BOOL _isSearching; /** 记录当前搜索状态 */
}

@property (strong, nonatomic) UIButton *collectBtn;/** 我的收藏按钮 */
@property (strong, nonatomic) UIButton *introduceBtn;/** 我的发布按钮 */
@property (strong, nonatomic) PGCSearchView *searchView;/** 搜索框 */
@property (strong, nonatomic) JSDropDownMenu *menu;/** 下拉菜单 */
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
    [PGCNotificationCenter removeObserver:self name:kRefreshDemandAndSupplyData object:nil];
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
    _timeDatas = @[@"不限", @"一天", @"三天", @"一周", @"一个月", @"三个月", @"半年", @"一年"];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"供应信息";
    self.view.backgroundColor = PGCBackColor;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.leftBarButtonItem = [self barButtonItem:CGRectMake(0, 0, 60, 40) tag:HeartBarTag title:@"我的收藏" imageName:@"我的收藏"];
    self.navigationItem.rightBarButtonItem= [self barButtonItem:CGRectMake(0, 0, 60, 40) tag:IntroduceBarTag title:@"我的发布" imageName:@"发布加号"];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.menu];
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(loadSupplyInfoData) name:kRefreshDemandAndSupplyData object:nil];
}


#pragma mark - Table Refresh

- (void)loadSupplyInfoData
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


#pragma mark - PGCSearchViewDelegate

- (void)searchView:(PGCSearchView *)searchView didSelectedSearchButton:(UIButton *)sender
{
    [searchView resignFirstResponder];
    
    
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
    for (PGCSupply *supply in self.dataSource) {
        [nameSearchs addObject:supply.title];
        [descSearchs addObject:supply.desc];
    }
    // 根据谓词在搜索源中查找符合条件的对象并且赋值给searchResults;
    [self.searchResults removeAllObjects];
    
    NSArray *nameResults = [nameSearchs filteredArrayUsingPredicate:predicate];
    for (NSString *string in nameResults) {
        for (PGCSupply *supply in self.dataSource) {
            if ([string isEqualToString:supply.title]) {
                [self.searchResults addObject:supply];
            }
        }
    }
    NSArray *descResults = [descSearchs filteredArrayUsingPredicate:predicate];
    for (NSString *string in descResults) {
        for (PGCSupply *supply in self.dataSource) {
            if ([string isEqualToString:supply.desc]) {
                [self.searchResults addObject:supply];
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



#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isSearching ? self.searchResults.count : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProcurementCell *cell = [tableView dequeueReusableCellWithIdentifier:kProcurementCell];
    cell.supply = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupply *supply = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:supply keyPath:@"supply" cellClass:[PGCProcurementCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupplyDetailVC *supplyVC = [[PGCSupplyDetailVC alloc] init];
    
    supplyVC.supply = _isSearching ? self.searchResults[indexPath.row] : self.dataSource[indexPath.row];
    
    [self.navigationController pushViewController:supplyVC animated:true];
}



#pragma mark - PGCDropMenuDaJSDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    return column < 2 ? true : false;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    return column < 2 ? 0.5 : 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    switch (column) {
        case 0: return _areaCurrentIndex; break;
        case 1: return _typeCurrentIndex; break;
        default: return _timeCurrentIndex; break;
    }
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    switch (column) {
        case 0:
        {
            if (leftOrRight == 0) {
                
                return _areaDatas.count;
            }
            else {
                PGCProvince *province = _areaDatas[leftRow];
                return province.cities.count;
            }
        }
            break;
        case 1:
        {
            if (leftOrRight == 0) {
                return _typeDatas.count;
                
            }
            else {
                PGCMaterialServiceTypes *type = _typeDatas[leftRow];
                return type.secondArray.count;
            }
        }
            break;
        default: return _timeDatas.count;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    switch (column) {
        case 0: return @"地区"; break;
        case 1: return @"类型"; break;
        default: return @"时间"; break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
        {
            if (indexPath.leftOrRight==0) {
                PGCProvince *province = _areaDatas[indexPath.row];
                return province.province;
            }
            else {
                PGCProvince *province = _areaDatas[indexPath.leftRow];
                PGCCity *city = province.cities[indexPath.row];
                return city.city;
            }
        }
            break;
        case 1:
        {
            if (indexPath.leftOrRight == 0) {
                PGCMaterialServiceTypes *type = _typeDatas[indexPath.row];
                return type.name;
            }
            else{
                PGCMaterialServiceTypes *type = _typeDatas[indexPath.leftRow];
                PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];
                return secondType.name;
            }
        }
            break;
        default: return _timeDatas[indexPath.row];
            break;
    }
}



#pragma mark - JSDropDownMenuDelegatetaSource

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
        {
            if (indexPath.leftOrRight == 0) {
                _areaCurrentIndex = indexPath.row;
                PGCProvince *province = _areaDatas[indexPath.row];
                
                if (!(province.cities.count > 0)) {
                    [self.parameters setObject:@(province.id) forKey:@"province_id"];
                }
            } else {
                PGCProvince *province = _areaDatas[indexPath.leftRow];
                PGCCity *city = province.cities[indexPath.row];
                [self.parameters setObject:@(city.id) forKey:@"city_id"];
            }
        }
            break;
        case 1:
        {
            if (indexPath.leftOrRight == 0) {
                _typeCurrentIndex = indexPath.row;
                PGCMaterialServiceTypes *type = _typeDatas[indexPath.row];
                
                if (!(type.secondArray.count > 0)) {
                    [self.parameters setObject:@(type.id) forKey:@"type_id"];
                }
            } else {
                PGCMaterialServiceTypes *type = _typeDatas[indexPath.leftRow];
                PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];
                [self.parameters setObject:@(secondType.id) forKey:@"city_id"];
            }
        }
            break;
        default:
        {
            _timeCurrentIndex = indexPath.row;
            NSArray *array = @[@0, @1, @3, @7 ,@30, @90, @180, @365];
            [self.parameters setObject:array[indexPath.row] forKey:@"days"];
        }
            break;
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
        _searchView = [[PGCSearchView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + 5, SCREEN_WIDTH, 40)];
        _searchView.backgroundColor = PGCBackColor;
        _searchView.delegate = self;
    }
    return _searchView;
}

- (JSDropDownMenu *)menu {
    if (!_menu) {
        _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, self.searchView.bottom_sd + 5) andHeight:40];
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
