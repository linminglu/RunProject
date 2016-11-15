//
//  PGCProjectInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoController.h"
#import "PGCProjectInfoNavigationBar.h"
#import "PGCProjectInfoCell.h"
#import "PGCMapTypeViewController.h"
#import "PGCProjectRootViewController.h"
#import "PGCSearchViewController.h"
#import "PGCProjectInfoDetailVC.h"
#import "JSDropDownMenu.h"
#import "PGCProvince.h"
#import "PGCProjectType.h"
#import "PGCProjectProgress.h"
#import "PGCProjectInfoAPIManager.h"
#import "PGCProjectInfo.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

static NSString * const kProjectInfoCell = @"ProjectInfoCell";

@interface PGCProjectInfoController () <UITableViewDataSource, UITableViewDelegate, JSDropDownMenuDataSource, JSDropDownMenuDelegate, PGCProjectInfoNavigationBarDelegate>
{
    NSMutableArray *_areaDatas;/** 地区数据源 */
    NSMutableArray *_typeDatas;/** 项目类型数据源 */
    NSMutableArray *_stageDatas;/** 项目阶段数据源 */
    
    NSInteger _currentProvinceIndex;/** 当前省份的下标 */
    NSInteger _currentTypeIndex;/** 当前类型的下标 */
    NSInteger _currentStageIndex;/** 当前阶段的下标 */
    
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
}

@property (strong, nonatomic) PGCProjectInfoNavigationBar *navigationBar;/** 自定义导航栏 */
@property (strong, nonatomic) JSDropDownMenu *menu;/** 下拉菜单视图 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 表格数据源 */
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 参数 */

- (void)initializeDataSource; /** 初始化数据 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectInfoController

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
}


#pragma mark - Initialize

- (void)initializeDataSource
{
    _areaDatas = [NSMutableArray arrayWithArray:[PGCProvince province].areaArray];
//    [_areaDatas insertObject:@"全国" atIndex:0];
    _typeDatas = [NSMutableArray arrayWithArray:[PGCProjectType projectType].projectTypes];
//    [_typeDatas insertObject:@"全部类别" atIndex:0];
    _stageDatas = [NSMutableArray arrayWithArray:[PGCProjectProgress projectProgress].progressArray];
//    [_stageDatas insertObject:@"全部阶段" atIndex:0];
    
    [PGCProjectInfoAPIManager getProjectsRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        if (status == RespondsStatusSuccess) {
            
            NSArray *resultArray = resultData[@"result"];
            
            for (id value in resultArray) {
                PGCProjectInfo *project = [[PGCProjectInfo alloc] init];
                [project mj_setKeyValues:value];
                
                [self.dataSource addObject:project];
            }
            if ([resultData[@"lastPage"] integerValue] >= _pageSize) {
                self.tableView.mj_footer.hidden = false;
                _page += 20;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.menu];
    [self.view addSubview:self.tableView];
    
    // 设置表格视图下拉刷新和上拉加载
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadProjectData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = true;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [PGCProgressHUD showMessage:@"未识别的网络" inView:self.view];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [PGCProgressHUD showMessage:@"不可达的网络(未连接)" inView:self.view];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}


#pragma mark - 
#pragma mark - 加载数据

- (void)loadProjectData
{
    _page = 1;
    _pageSize = 20;
    [self.dataSource removeAllObjects];
    
    [self.parameters setObject:@(-1) forKey:@"province_id"];
    [self.parameters setObject:@(-1) forKey:@"city_id"];
    [self.parameters setObject:@(-1) forKey:@"type_id"];
    [self.parameters setObject:@(-1) forKey:@"progress_id"];
    
    [PGCProjectInfoAPIManager getProjectsRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            
            NSArray *resultArray = resultData[@"result"];
            
            for (id value in resultArray) {
                PGCProjectInfo *project = [[PGCProjectInfo alloc] init];
                [project mj_setKeyValues:value];
                
                [self.dataSource addObject:project];
            }
            if ([resultData[@"lastPage"] integerValue] >= 20) {
                self.tableView.mj_footer.hidden = false;
                _page += 20;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData
{
    [PGCProjectInfoAPIManager getProjectsRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        if (status == RespondsStatusSuccess) {
            
            NSArray *resultArray = resultData[@"result"];
            
            if (resultArray.count > 0) {
                for (id value in resultArray) {
                    PGCProjectInfo *project = [[PGCProjectInfo alloc] init];
                    [project mj_setKeyValues:value];
                    
                    [self.dataSource addObject:project];
                }
                if ([resultData[@"lastPage"] integerValue] >= _page + 10) {
                    
                    _page += 10;
                    [self.tableView.mj_footer endRefreshing];
                    
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableView reloadData];
                
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectInfoCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.project = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfo *projectInfo = self.dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:projectInfo keyPath:@"project" cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
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
    PGCProjectInfo *projectInfo = self.dataSource[indexPath.row];
    PGCProjectInfoDetailVC *detailVC = [[PGCProjectInfoDetailVC alloc] init];
    detailVC.projectInfoDetail = projectInfo;
    [self.navigationController pushViewController:detailVC animated:true];
}



#pragma mark -
#pragma mark - PGCProjectInfoNavigationBarDelegate

- (void)projectInfoNavigationBar:(PGCProjectInfoNavigationBar *)projectInfoNavigationBar tapItem:(NSInteger)tag
{
    PGCProjectRootViewController *rootVC = [[PGCProjectRootViewController alloc] init];
    switch (tag) {
        case mapItemTag:
        {
            PGCMapTypeViewController *mapVC = [[PGCMapTypeViewController alloc] init];
            [self.navigationController pushViewController:mapVC animated:true];
        }
            break;
        case recordItemTag:
        {
            PGCTokenManager *manager = [PGCTokenManager tokenManager];
            [manager readAuthorizeData];
            PGCUserInfo *user = manager.token.user;
            if (user == nil) {
                [PGCProgressHUD showMessage:@"请先登录" inView:KeyWindow];
                return;
            }
            rootVC.navigationItem.title = @"浏览记录";
            rootVC.bottomBtnTitle = @"删除";
            rootVC.projectType = 1;
            
            [self.navigationController pushViewController:rootVC animated:true];
        }
            break;
        case collectItemTag:
        {
            PGCTokenManager *manager = [PGCTokenManager tokenManager];
            [manager readAuthorizeData];
            PGCUserInfo *user = manager.token.user;
            if (user == nil) {
                [PGCProgressHUD showMessage:@"请先登录" inView:KeyWindow];
                return;
            }
            rootVC.navigationItem.title = @"我的收藏";
            rootVC.bottomBtnTitle = @"取消收藏";
            rootVC.projectType = 2;
            
            [self.navigationController pushViewController:rootVC animated:true];
        }
            break;
        case searchItemTag:
        {
            PGCSearchViewController *searchVC = [[PGCSearchViewController alloc] init];
            searchVC.searchData = self.dataSource;
            searchVC.navigationItem.hidesBackButton = true;
            [self.navigationController pushViewController:searchVC animated:false];
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark - PGCDropMenuDaJSDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu
{
    return 3;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    return column == 2 ? true : false;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    return column == 0 ? true : false;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    return column == 0 ? 0.5 : 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    switch (column) {
        case 0: return _currentProvinceIndex; break;
        case 1: return _currentTypeIndex; break;
        default: return 0;  break;
    }
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    switch (column) {
        case 0:
        {
            if (leftOrRight == 0) {
                return _areaDatas.count;
            } else {
                PGCProvince *province = _areaDatas[leftRow];
                NSArray *arr = province.city;
                return arr.count;
            }
        }
            break;
        case 1: return _typeDatas.count; break;
        default: return _stageDatas.count; break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    switch (column) {
        case 0: return @"地区"; break;
        case 1: return @"类别"; break;
        default: return @"阶段"; break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
        {
            if (indexPath.leftOrRight == 0) {
                PGCProvince *province = _areaDatas[indexPath.row];
                return province ? province.province : _areaDatas[0];
                
            } else {
                PGCProvince *province = _areaDatas[indexPath.leftRow];
                NSArray *rightArr = province.city;
                PGCCity *city = rightArr[indexPath.row];
                return city.city;
            }
        }
            break;
        case 1:
        {
            PGCProjectType *type = _typeDatas[indexPath.row];
            return type ? type.name : _typeDatas[0];
        }
            break;
        default:
        {
            PGCProjectProgress *progress = _stageDatas[indexPath.row];
            return progress ? progress.name : _stageDatas[0];
        }
            break;
    }
}


#pragma mark -
#pragma mark - JSDropDownMenuDelegatetaSource

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
        {
            if (indexPath.leftOrRight == 0) {
                _currentProvinceIndex = indexPath.row;
                PGCProvince *province = _areaDatas[indexPath.leftRow];
                [self.parameters setObject:@(province.id) forKey:@"province_id"];
                
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
            _currentTypeIndex = indexPath.row;
            PGCProjectType *type = _typeDatas[indexPath.row];
            [self.parameters setObject:@(type.id) forKey:@"type_id"];
        }
            break;
        default:
        {
            _currentStageIndex = indexPath.row;
            PGCProjectProgress *progress = _stageDatas[indexPath.row];
            [self.parameters setObject:@(progress.id) forKey:@"progress_id"];
        }
            break;
    }
    [self loadProjectData];
}


#pragma mark -
#pragma mark - Getter

- (PGCProjectInfoNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[PGCProjectInfoNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_AND_NAVIGATION_HEIGHT)];
        _navigationBar.backgroundColor = PGCThemeColor;
        _navigationBar.delegate = self;
    }
    return _navigationBar;
}

- (JSDropDownMenu *)menu
{
    if (!_menu) {
        _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, self.navigationBar.bottom) andHeight:40];
        _menu.backgroundColor = [UIColor whiteColor];
        _menu.dataSource = self;
        _menu.delegate = self;
    }
    return _menu;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.menu.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - self.menu.bottom) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kProjectInfoCell];
    }
    return _tableView;
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
        
        _page = 1;
        _pageSize = 20;
        [_parameters setObject:@(_page) forKey:@"page"];
        [_parameters setObject:@(_pageSize) forKey:@"page_size"];
        
        [[PGCTokenManager tokenManager] readAuthorizeData];
        PGCUserInfo *user = [PGCTokenManager tokenManager].token.user;
        if (user) {
            [_parameters setObject:@(user.id) forKey:@"user_id"];
            
        }
    }
    return _parameters;
}

@end
