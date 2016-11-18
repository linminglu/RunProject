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
#import "PGCSearchBar.h"
#import "PGCSupplyDetailVC.h"
#import "PGCDemandDetailVC.h"
#import "PGCDemandCollectVC.h"
#import "PGCSupplyCollectVC.h"
#import "PGCDemandIntroduceVC.h"
#import "PGCSupplyIntroduceVC.h"
#import "PGCProvince.h"
#import "PGCMaterialServiceTypes.h"
#import "PGCSupply.h"
#import "PGCDemand.h"
#import "PGCSupplyAndDemandAPIManager.h"
#import "PGCSupplyAPIManager.h"
#import "PGCDemandAPIManager.h"
#import "PGCManager.h"

#define TopButtonTag 500
#define CenterButtonTag 400

@interface PGCSupplyAndDemandController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JSDropDownMenuDataSource, JSDropDownMenuDelegate>
{
    NSArray *_areaDatas;
    NSArray *_typeDatas;
    NSArray *_timeDatas;
    
    NSInteger _areaCurrentIndex;
    NSInteger _typeCurrentIndex;
    NSInteger _timeCurrentIndex;
    
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
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
@property (weak, nonatomic) IBOutlet UITableView *tableView;// 表格视图
@property (strong, nonatomic) UIView *filterView;// 顶部标题按钮绿色游标
@property (strong, nonatomic) PGCSearchBar *searchBar;// 搜索条
@property (nonatomic, assign) BOOL isSelected;// 选择按钮是否被点击
@property (assign, nonatomic) BOOL demandNotSupply;// 是否为需求信息
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 参数 */
@property (strong, nonatomic) NSMutableArray *demandDataSource;/** 需求信息数据源 */
@property (strong, nonatomic) NSMutableArray *supplyDataSource;/** 供应信息数据源 */

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
    
    _areaDatas = [PGCProvince province].areaArray;
    _typeDatas = [PGCMaterialServiceTypes materialServiceTypes].typeArray;    
    _timeDatas = @[@"一天", @"三天", @"一周", @"一个月", @"三个月", @"半年", @"一年"];
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
    
    // 添加游标
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(1, STATUS_AND_NAVIGATION_HEIGHT - 2, SCREEN_WIDTH / 2 - 2, 2)];
    self.filterView.backgroundColor = PGCTintColor;
    [self.view addSubview:self.filterView];
    
    // 设置搜索条
    self.searchBar = [[PGCSearchBar alloc] init];
    self.searchBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 2 - 20, 34);
    self.searchBar.center = CGPointMake(SCREEN_WIDTH / 4, self.centerBackView.height_sd / 2);
    self.searchBar.layer.cornerRadius = 17;
    self.searchBar.layer.masksToBounds = true;
    self.searchBar.tintColor = PGCTintColor;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.enablesReturnKeyAutomatically = true;
    self.searchBar.delegate = self;
    [self.centerBackView addSubview:self.searchBar];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, self.centerBackView.bottom_sd) andHeight:40];
    menu.backgroundColor = [UIColor whiteColor];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    [self.tableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
    
    // 设置表格视图下拉刷新和上拉加载
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSupplyAndDemandData)];
    header.automaticallyChangeAlpha = true;
    header.lastUpdatedTimeLabel.hidden = true;
    self.tableView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSupplyAndDemandData)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    footer.ignoredScrollViewContentInsetBottom = 30;
    self.tableView.mj_footer = footer;
    
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


#pragma mark -
#pragma mark - 网络请求数据
// 需求信息列表
- (void)requestDemandData
{
    [PGCDemandAPIManager getDemandWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            
            for (id value in resultData[@"result"]) {
                PGCDemand *demand = [[PGCDemand alloc] init];
                [demand mj_setKeyValues:value];
                
                [self.demandDataSource addObject:demand];
            }
            _page += 10;
            [self.tableView reloadData];
        }
    }];
}

// 供应信息列表
- (void)requestSupplyData
{
    [PGCSupplyAPIManager getSupplyWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            
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

#pragma mark - Table Refresh

- (void)loadSupplyAndDemandData
{
    _page = 1;
    _pageSize = 10;
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(_pageSize) forKey:@"page_size"];
    
    if (_demandNotSupply) {
        [self.demandDataSource removeAllObjects];
        
        [self requestDemandData];
        
    } else {
        
        [self.supplyDataSource removeAllObjects];
        
        [self requestSupplyData];
    }
}

- (void)loadMoreSupplyAndDemandData
{
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(1) forKey:@"page_size"];
    
    if (_demandNotSupply) {
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
- (IBAction)demandAndSupplyBtn:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.filterView.centerX = sender.centerX;
        
        switch (sender.tag) {
            case TopButtonTag:
            {
                [self actionWithButton:self.demandBtn
                           otherButton:self.supplyBtn
                               enabled:false
                              selected:true];
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


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
    return true;
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _demandNotSupply ? self.demandDataSource.count : self.supplyDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupplyAndDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyAndDemandCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_demandNotSupply) {
        cell.demand = self.demandDataSource[indexPath.row];
    } else {
        cell.supply = self.supplyDataSource[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_demandNotSupply) {
        PGCDemand *demand = self.demandDataSource[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:demand keyPath:@"demand" cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
    } else {
        PGCSupply *supply = self.supplyDataSource[indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:supply keyPath:@"supply" cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_demandNotSupply) {
        PGCDemandDetailVC *demandVC = [[PGCDemandDetailVC alloc] init];
        
        demandVC.demand = self.demandDataSource[indexPath.row];
        
        [self.navigationController pushViewController:demandVC animated:true];
        
    } else {
        PGCSupplyDetailVC *supplyVC = [[PGCSupplyDetailVC alloc] init];
        
        supplyVC.supply = self.supplyDataSource[indexPath.row];
        
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
                NSArray *arr = province.city;
                
                return arr.count;
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
                NSArray *rightArr = province.city;
                PGCCity *city = rightArr[indexPath.row];
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
                
                if (!(province.city.count > 0)) {
                    [self.parameters setObject:@(province.id) forKey:@"province_id"];
                }
            } else {
                PGCProvince *province = _areaDatas[indexPath.leftRow];
                NSArray *cities = province.city;
                PGCCity *city = cities[indexPath.row];
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
            NSArray *array = @[@1, @3, @7 ,@30, @90, @180, @365];
            [self.parameters setObject:array[indexPath.row] forKey:@"days"];
        }
            break;
    }
}



#pragma mark - Getter

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
        
        PGCManager *manager = [PGCManager manager];
        [manager readTokenData];
        PGCUser *user = manager.token.user;
        if (user) {
            _page = 1;
            _pageSize = 10;
            [_parameters setObject:@(user.user_id) forKey:@"user_id"];
            [_parameters setObject:@"iphone" forKey:@"client_type"];
            [_parameters setObject:manager.token.token forKey:@"token"];
            [_parameters setObject:@0 forKey:@"days"];
            [_parameters setObject:@(_page) forKey:@"page"];
            [_parameters setObject:@(_pageSize) forKey:@"page_size"];
        } else {
            [PGCProgressHUD showMessage:@"请先登录" toView:self.view];
            [self.tableView.mj_header endRefreshing];
        }
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


@end
