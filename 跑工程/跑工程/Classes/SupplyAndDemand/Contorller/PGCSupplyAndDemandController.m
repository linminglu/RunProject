//
//  PGCSupplyAndDemandController.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandController.h"
#import "PGCSupplyAndDemandCell.h"
#import "JSDropDownMenu.h"
#import "PGCSupplyDetailVC.h"
#import "PGCDemandDetailVC.h"
#import "PGCDemandCollectVC.h"
#import "PGCSupplyCollectVC.h"
#import "PGCDemandIntroduceVC.h"
#import "PGCSupplyIntroduceVC.h"
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"
#import "PGCSupply.h"
#import "PGCDemand.h"
#import "PGCSupplyAPIManager.h"
#import "PGCDemandAPIManager.h"
#import "PGCManager.h"

#define TopButtonTag 500
#define CenterButtonTag 400

@interface PGCSupplyAndDemandController () <UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource, JSDropDownMenuDelegate>
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

#pragma mark - 控件约束属性
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBtnX;// 我的收藏按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceBtnX;// 我的发布按钮X

#pragma mark - 控件属性
@property (weak, nonatomic) IBOutlet UIButton *demandBtn;// 顶部需求按钮
@property (weak, nonatomic) IBOutlet UIButton *supplyBtn;// 顶部供应按钮
@property (weak, nonatomic) IBOutlet UIView *centerBackView;// 搜索框背景
@property (weak, nonatomic) IBOutlet UIButton *conllectionBtn;// 我的收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *introduceBtn;// 我的发布按钮
@property (strong, nonatomic) UIView *filterView;// 顶部标题按钮绿色游标
@property (strong, nonatomic) UITextField *searchBar;// 搜索框
@property (strong, nonatomic) JSDropDownMenu *menu;/** 下拉菜单 */
@property (strong, nonatomic) UITableView *tableView;// 表格视图
@property (nonatomic, assign) BOOL isSelected;// 选择按钮是否被点击
@property (assign, nonatomic) BOOL demandNotSupply;// 是否为需求信息
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 参数 */
@property (strong, nonatomic) NSMutableArray *demandDataSource;/** 需求信息数据源 */
@property (strong, nonatomic) NSMutableArray *supplyDataSource;/** 供应信息数据源 */
@property (strong, nonatomic) NSMutableArray *searchDemandResults;/** 搜索需求信息结果 */
@property (strong, nonatomic) NSMutableArray *searchSupplyResults;/** 搜索供应信息结果 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCSupplyAndDemandController

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kRefreshDemandAndSupplyData object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = false;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
    [self registerNotification];
}


#pragma mark -
#pragma mark - Initialize

- (void)initializeDataSource
{
    _isSelected = false;
    _demandNotSupply = true;
    _isSearching = false;
    
    _areaDatas = [[PGCAreaManager manager] setAreaData];
    
    _typeDatas = [[PGCMaterialServiceTypes materialServiceTypes] setMaterialTypes];
    
    _timeDatas = @[@"不限", @"一天", @"三天", @"一周", @"一个月", @"三个月", @"半年", @"一年"];
}

- (void)initializeUserInterface
{
    // 控件布局
    CGFloat buttonW = 70;
    self.introduceBtnX.constant =(SCREEN_WIDTH / 2 - buttonW * 2) / 3;
    self.collectionBtnX.constant =(SCREEN_WIDTH / 2 - buttonW * 2) / 3;
    
    // 设置需求按钮初始状态为选中，用户交互停用
    self.demandBtn.selected = true;
    self.demandBtn.userInteractionEnabled = false;
    
    [self.view addSubview:self.filterView];
    [self.centerBackView addSubview:self.searchBar];
    [self.view addSubview:self.menu];
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(refreshTableData:) name:kRefreshDemandAndSupplyData object:nil];
}


#pragma mark -
#pragma mark - NSNotificationCenter

- (void)refreshTableData:(NSNotification *)notifi
{
    if ([notifi.object isKindOfClass:[PGCDemand class]]) {
        _demandNotSupply = true;
    }
    if ([notifi.object isKindOfClass:[PGCSupply class]]) {
        _demandNotSupply = false;
    }
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark -
#pragma mark - Table Refresh

- (void)loadSupplyAndDemandData
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (user) {
        [self.parameters setObject:@(user.user_id) forKey:@"user_id"];
        [self.parameters setObject:@"iphone" forKey:@"client_type"];
        [self.parameters setObject:manager.token.token forKey:@"token"];
    } else {
        [PGCProgressHUD showMessage:@"请先登录" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    _page = 1;
    _pageSize = 10;
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(_pageSize) forKey:@"page_size"];
    
    if (_demandNotSupply) {
        // 需求信息列表
        [PGCDemandAPIManager getDemandWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            [self.tableView.mj_header endRefreshing];
            
            if (status == RespondsStatusSuccess) {
                [self.demandDataSource removeAllObjects];
                
                for (id value in resultData[@"result"]) {
                    PGCDemand *demand = [[PGCDemand alloc] init];
                    [demand mj_setKeyValues:value];
                    
                    [self.demandDataSource addObject:demand];
                }
                _page += 10;
                [self.tableView reloadData];
            }
        }];
    } else {
        // 供应信息列表
        [PGCSupplyAPIManager getSupplyWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            [self.tableView.mj_header endRefreshing];
            
            if (status == RespondsStatusSuccess) {
                [self.supplyDataSource removeAllObjects];
                
                for (id value in resultData[@"result"]) {
                    PGCSupply *supply = [[PGCSupply alloc] init];
                    [supply mj_setKeyValues:value];
                    
                    [self.supplyDataSource addObject:supply];
                }
                _page += 10;
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)loadMoreSupplyAndDemandData
{
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(1) forKey:@"page_size"];
    
    if (_demandNotSupply) {
        // 需求信息列表
        [PGCDemandAPIManager getDemandWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                NSArray *resultArr = resultData[@"result"];
                if (resultArr.count > 0) {
                    for (id value in resultArr) {
                        PGCDemand *demand = [[PGCDemand alloc] init];
                        [demand mj_setKeyValues:value];
                        
                        [self.demandDataSource addObject:demand];
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
    } else {
        // 供应信息列表
        [PGCSupplyAPIManager getSupplyWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                NSArray *resultArr = resultData[@"result"];
                if (resultArr.count > 0) {
                    for (id value in resultArr) {
                        PGCSupply *supply = [[PGCSupply alloc] init];
                        [supply mj_setKeyValues:value];
                        
                        [self.supplyDataSource addObject:supply];
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
}


#pragma mark - xib按钮点击事件

- (void)actionWithButton:(UIButton *)button
             otherButton:(UIButton *)otherButton
                 enabled:(BOOL)enabled
                selected:(BOOL)selected {
    button.userInteractionEnabled = enabled;
    otherButton.userInteractionEnabled = !button.userInteractionEnabled;
    
    button.selected = selected;
    otherButton.selected = !button.selected;
}

/**
 需求和供应信息按钮点击事件
 
 @param sender
 */
- (IBAction)demandAndSupplyBtn:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.filterView.centerX = sender.centerX;
        
        _isSearching = false;
        [self.searchBar resignFirstResponder];
        
        switch (sender.tag) {
            case TopButtonTag:
            {
                [self actionWithButton:self.demandBtn
                           otherButton:self.supplyBtn
                               enabled:false
                              selected:true];
                [self.searchDemandResults removeAllObjects];
                _demandNotSupply = true;
                if (!(self.demandDataSource.count > 0)) {
                    [self loadSupplyAndDemandData];
                } else {
                    [self.tableView reloadData];
                }
            }
                break;
            default:
            {
                [self actionWithButton:self.demandBtn
                           otherButton:self.supplyBtn
                               enabled:true
                              selected:false];
                [self.searchSupplyResults removeAllObjects];
                _demandNotSupply = false;
                if (!(self.supplyDataSource.count > 0)) {
                    [self loadSupplyAndDemandData];
                } else {
                    [self.tableView reloadData];
                }
            }
                break;
        }
    } completion:^(BOOL finished) {
    }];
}

/**
 我的收藏和发布按钮点击事件
 
 @param sender
 */
- (IBAction)collectionAndIntroduceBtn:(UIButton *)sender
{    
    switch (sender.tag) {
        case CenterButtonTag:
        {
            if (_demandNotSupply) {
                // 推送到 需求->我的收藏 界面
                PGCDemandCollectVC *demandCollectVC = [[PGCDemandCollectVC alloc] init];
                
                [self.navigationController pushViewController:demandCollectVC animated:true];
                
            } else {
                // 推送到 供应->我的收藏 界面
                PGCSupplyCollectVC *supplyCollectVC = [[PGCSupplyCollectVC alloc] init];;
                
                [self.navigationController pushViewController:supplyCollectVC animated:true];
            }
        }
            break;
        default:
        {
            if (_demandNotSupply) {
                // 推送到 需求->我的发布 界面
                PGCDemandIntroduceVC *demandIntroduceVC = [[PGCDemandIntroduceVC alloc] init];
                
                [self.navigationController pushViewController:demandIntroduceVC animated:true];
                
            } else {
                // 推送到 供应->我的发布 界面
                PGCSupplyIntroduceVC *supplyIntroduceVC = [[PGCSupplyIntroduceVC alloc] init];;
                
                [self.navigationController pushViewController:supplyIntroduceVC animated:true];
            }
        }
            break;
    }
}


#pragma mark - TextField Event

- (void)textFieldDidChange:(UITextField *)textField
{
    if (!(textField.text.length > 0)) {
        _isSearching = false;
        [self.tableView reloadData];
        return;
    }
    _isSearching = true;
    
    if (_demandNotSupply) {
        // 获取搜索框上的文本
        NSString *text = textField.text;
        // 谓词判断，创建搜索条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", text];
        // 获取搜索源
        NSMutableArray *nameSearchs = [NSMutableArray array];
        NSMutableArray *descSearchs = [NSMutableArray array];
        for (PGCDemand *demand in self.demandDataSource) {
            [nameSearchs addObject:demand.title];
            [descSearchs addObject:demand.desc];
        }
        // 根据谓词在搜索源中查找符合条件的对象并且赋值给searchResults;
        [self.searchDemandResults removeAllObjects];
        
        NSArray *nameResults = [nameSearchs filteredArrayUsingPredicate:predicate];
        for (NSString *string in nameResults) {
            for (PGCDemand *demand in self.demandDataSource) {
                if ([string isEqualToString:demand.title]) {
                    [self.searchDemandResults addObject:demand];
                }
            }
        }
        NSArray *descResults = [descSearchs filteredArrayUsingPredicate:predicate];
        for (NSString *string in descResults) {
            for (PGCDemand *demand in self.demandDataSource) {
                if ([string isEqualToString:demand.desc]) {
                    [self.searchDemandResults addObject:demand];
                }
            }
        }
    } else {
        // 获取搜索框上的文本
        NSString *text = textField.text;
        // 谓词判断，创建搜索条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", text];
        // 获取搜索源
        NSMutableArray *nameSearchs = [NSMutableArray array];
        NSMutableArray *descSearchs = [NSMutableArray array];
        for (PGCSupply *supply in self.supplyDataSource) {
            [nameSearchs addObject:supply.title];
            [descSearchs addObject:supply.desc];
        }
        // 根据谓词在搜索源中查找符合条件的对象并且赋值给searchResults;
        [self.searchSupplyResults removeAllObjects];
        
        NSArray *nameResults = [nameSearchs filteredArrayUsingPredicate:predicate];
        for (NSString *string in nameResults) {
            for (PGCSupply *supply in self.supplyDataSource) {
                if ([string isEqualToString:supply.title]) {
                    [self.searchSupplyResults addObject:supply];
                }
            }
        }
        NSArray *descResults = [descSearchs filteredArrayUsingPredicate:predicate];
        for (NSString *string in descResults) {
            for (PGCSupply *supply in self.supplyDataSource) {
                if ([string isEqualToString:supply.desc]) {
                    [self.searchSupplyResults addObject:supply];
                }
            }
        }
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_demandNotSupply) {
        return _isSearching ? self.searchDemandResults.count : self.demandDataSource.count;
    }
    return _isSearching ? self.searchSupplyResults.count : self.supplyDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupplyAndDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyAndDemandCell];
    
    if (_demandNotSupply) {
        cell.demand = _isSearching ? self.searchDemandResults[indexPath.row] : self.demandDataSource[indexPath.row];
    } else {
        cell.supply = _isSearching ? self.searchSupplyResults[indexPath.row] : self.supplyDataSource[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_demandNotSupply) {
        PGCDemand *demand = _isSearching ? self.searchDemandResults[indexPath.row] : self.demandDataSource[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:demand keyPath:@"demand" cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
    } else {
        PGCSupply *supply = _isSearching ? self.searchSupplyResults[indexPath.row] : self.supplyDataSource[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:supply keyPath:@"supply" cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_demandNotSupply) {
        PGCDemandDetailVC *demandVC = [[PGCDemandDetailVC alloc] init];
        
        demandVC.demand = _isSearching ? self.searchDemandResults[indexPath.row] : self.demandDataSource[indexPath.row];
        
        [self.navigationController pushViewController:demandVC animated:true];
        
    } else {
        PGCSupplyDetailVC *supplyVC = [[PGCSupplyDetailVC alloc] init];
        
        supplyVC.supply = _isSearching ? self.searchSupplyResults[indexPath.row] : self.supplyDataSource[indexPath.row];
        
        [self.navigationController pushViewController:supplyVC animated:true];
    }
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
    [self loadSupplyAndDemandData];
}



#pragma mark - Getter

- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] initWithFrame:CGRectMake(1, STATUS_AND_NAVIGATION_HEIGHT - 2, SCREEN_WIDTH / 2 - 2, 2)];
        _filterView.backgroundColor = PGCTintColor;
    }
    return _filterView;
}

- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc] init];
        _searchBar.font = [UIFont systemFontOfSize:13];
        _searchBar.borderStyle = UITextBorderStyleNone;
        _searchBar.textColor = RGB(102, 102, 102);
        _searchBar.placeholder = @"请输入关键字";
        _searchBar.background = [UIImage imageNamed:@"搜索框背景"];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.width_sd = 30;
        searchIcon.height_sd = 30;
        searchIcon.image = [UIImage imageNamed:@"搜索"];
        searchIcon.contentMode = UIViewContentModeCenter;
        _searchBar.leftView = searchIcon;
        _searchBar.leftViewMode = UITextFieldViewModeAlways;
        
        _searchBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 2 - 10, 34);
        _searchBar.center = CGPointMake(SCREEN_WIDTH / 4, self.centerBackView.height_sd / 2);
        _searchBar.layer.cornerRadius = 17.0;
        _searchBar.layer.masksToBounds = true;
        _searchBar.tintColor = PGCTintColor;
        _searchBar.returnKeyType = UIReturnKeySearch;
        [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchBar;
}

- (JSDropDownMenu *)menu {
    if (!_menu) {
        _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, self.centerBackView.bottom_sd) andHeight:40];
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
        [_tableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
        // 设置表格视图下拉刷新和上拉加载
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSupplyAndDemandData)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSupplyAndDemandData)];
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


- (NSMutableArray *)demandDataSource {
    if (!_demandDataSource) {
        _demandDataSource = [NSMutableArray array];
    }
    return _demandDataSource;
}


- (NSMutableArray *)supplyDataSource {
    if (!_supplyDataSource) {
        _supplyDataSource = [NSMutableArray array];
    }
    return _supplyDataSource;
}

- (NSMutableArray *)searchDemandResults {
    if (!_searchDemandResults) {
        _searchDemandResults = [NSMutableArray array];
    }
    return _searchDemandResults;
}

- (NSMutableArray *)searchSupplyResults {
    if (!_searchSupplyResults) {
        _searchSupplyResults = [NSMutableArray array];
    }
    return _searchSupplyResults;
}


@end
