//
//  PGCProjectInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoController.h"
#import "PGCProjectInfoCell.h"
#import "PGCMapTypeViewController.h"
#import "PGCProjectRootViewController.h"
#import "PGCSearchViewController.h"
#import "PGCProjectDetailViewController.h"
//#import "JSDropDownMenu.h"
#import "DropDownMenu.h"
#import "PGCProjectInfoAPIManager.h"
#import "PGCProject.h"
#import "PGCAreaManager.h"
#import "PGCProjectManager.h"
#import "PGCAreaAPIManager.h"

typedef NS_ENUM(NSUInteger, BarItemTag) {
    MapBtnTag,
    RecordBtnTag,
    HeartBtnTag,
    SearchBtnTag,
};

@interface PGCProjectInfoController () <UITableViewDataSource, UITableViewDelegate, DropDownMenuDataSource, DropDownMenuDelegate>
{
    NSArray *_areaDatas;/** 地区数据源 */
    NSArray *_typeDatas;/** 项目类型数据源 */
    NSArray *_progressDatas;/** 项目阶段数据源 */
    
    NSInteger _currentProvinceIndex;/** 当前省份的下标 */
    NSInteger _currentTypeIndex;/** 当前类型的下标 */
    NSInteger _currentStageIndex;/** 当前阶段的下标 */
    
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
    
    BOOL _isSearch;/** 是否是搜索的数据源 */
}

@property (weak, nonatomic) UIView *searchTitleView;/** 搜索标题视图 */
@property (strong, nonatomic) DropDownMenu *menu;/** 下拉菜单视图 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 参数 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 表格数据源 */
@property (strong, nonatomic) NSMutableArray *searchDataSource;/** 搜索数据源 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCProjectInfoController

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kRefreshCollectTable object:nil];
    [PGCNotificationCenter removeObserver:self name:kSearchProjectData object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeDataSource
{
    // 网络请求城市列表数据
    [PGCAreaAPIManager getCitiesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *cities) {
        if (status == RespondsStatusSuccess) {
            // 网络请求省份列表数据
            [PGCAreaAPIManager getProvincesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *provinces) {
                if (status == RespondsStatusSuccess) {
                    _areaDatas = [[PGCAreaManager manager] setAreaData];                    
                    [self.menu reloadData];
                }
            }];
        }
    }];
    // 网络请求项目类型数据
    [PGCProjectInfoAPIManager getProjectTypesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        if (status == RespondsStatusSuccess) {
            _typeDatas = [[PGCProjectManager manager] setProjectType];
            [self.menu reloadData];
        }
    }];
    // 网络请求项目进度数据
    [PGCProjectInfoAPIManager getProjectProgressesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        if (status == RespondsStatusSuccess) {
            _progressDatas = [[PGCProjectManager manager] setProjectProgress];
            [self.menu reloadData];
        }
    }];
}

- (void)initializeUserInterface
{
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *map = [self barButtonItem:CGRectMake(0, 0, 45, 40)
                                           tag:MapBtnTag
                                         title:@"地图模式"
                                     imageName:@"map"];
    self.navigationItem.leftBarButtonItem = map;
    UIBarButtonItem *search = [self barButtonItem:CGRectMake(0, 0, 30, 40)
                                              tag:SearchBtnTag
                                            title:@"搜索"
                                        imageName:@"工程搜索"];
    UIBarButtonItem *heart = [self barButtonItem:CGRectMake(0, 0, 45, 40)
                                             tag:HeartBtnTag
                                           title:@"我的收藏"
                                       imageName:@"我的收藏"];
    UIBarButtonItem *record = [self barButtonItem:CGRectMake(0, 0, 45, 40)
                                              tag:RecordBtnTag
                                            title:@"查看记录"
                                        imageName:@"查看记录"];
    self.navigationItem.rightBarButtonItems = @[search, heart, record];
    
    _isSearch = false;
    
    [self.view addSubview:self.menu];
    [self.menu selectDefalutIndexPath];
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)registerNotification {
    // 添加项目收藏与取消收藏的通知
    [PGCNotificationCenter addObserver:self selector:@selector(loadProjectData) name:kRefreshCollectTable object:nil];
    // 添加搜索项目的通知
    [PGCNotificationCenter addObserver:self selector:@selector(searchProjectData:) name:kSearchProjectData object:nil];
}


#pragma mark - 
#pragma mark - NSNotificationCenter

- (void)searchProjectData:(NSNotification *)notifi
{
    NSString *key = @"key_word";
    if ([notifi.userInfo objectForKey:key]) {
        _isSearch = true;
        _page = 1;
        _pageSize = 10;
        NSString *key_word = [notifi.userInfo objectForKey:key];
        [self.parameters setObject:@(_page) forKey:@"page"];
        [self.parameters setObject:@(_pageSize) forKey:@"page_size"];
        [self.parameters setObject:key_word forKey:@"key_word"];
        
        MBProgressHUD *hud = [PGCProgressHUD showProgress:@"搜索中..." toView:self.view];
        
        __weak typeof(self) weakSelf = self;
        [PGCProjectInfoAPIManager getProjectsRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                // 清空之前的数据
                [self.searchDataSource removeAllObjects];
                // 添加新数据
                for (id value in resultData[@"result"]) {
                    PGCProject *project = [[PGCProject alloc] init];
                    [project mj_setKeyValues:value];
                    [self.searchDataSource addObject:project];
                }
                _page += 10;
                [self.tableView reloadData];
                [weakSelf animationWithTitle:key_word forward:true];
            }
        }];
    }
}


#pragma mark - 
#pragma mark - Table Refresh

- (void)loadProjectData
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
    
    [PGCProjectInfoAPIManager getProjectsRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            // 清空之前的数据
            [self.dataSource removeAllObjects];
            // 添加新数据
            for (id value in resultData[@"result"]) {
                PGCProject *project = [[PGCProject alloc] init];
                [project mj_setKeyValues:value];
                [self.dataSource addObject:project];
            }
            _page += 10;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData
{
    [self.parameters setObject:@(_page) forKey:@"page"];
    [self.parameters setObject:@(1) forKey:@"page_size"];
    
    [PGCProjectInfoAPIManager getProjectsRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            NSArray *resultArray = resultData[@"result"];
            if (resultArray.count > 0) {
                if (_isSearch) {
                    for (id value in resultData[@"result"]) {
                        PGCProject *project = [[PGCProject alloc] init];
                        [project mj_setKeyValues:value];
                        [self.searchDataSource addObject:project];
                    }
                } else {
                    for (id value in resultData[@"result"]) {
                        PGCProject *project = [[PGCProject alloc] init];
                        [project mj_setKeyValues:value];
                        [self.dataSource addObject:project];
                    }
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


#pragma mark -
#pragma mark - Event

- (void)barButtonItemEvent:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    PGCProjectRootViewController *rootVC = [[PGCProjectRootViewController alloc] init];
    switch (sender.tag) {
        case MapBtnTag:
        {
            PGCMapTypeViewController *mapVC = [[PGCMapTypeViewController alloc] init];
            NSMutableArray *array = [NSMutableArray array];
            for (PGCProject *model in self.dataSource) {
                [array addObject:@{@"lat":model.lat, @"lng":model.lng}];
            }
            mapVC.coordinates = array;
            [self.navigationController pushViewController:mapVC animated:true];
        }
            break;
        case RecordBtnTag:
        {
            if (!user) {
                [MBProgressHUD showError:@"请先登录" toView:self.view];
                return;
            }
            rootVC.title = @"浏览记录";
            rootVC.bottomBtnTitle = @"删除";
            rootVC.projectType = 1;
            
            [self.navigationController pushViewController:rootVC animated:true];
        }
            break;
        case HeartBtnTag:
        {
            if (!user) {
                [MBProgressHUD showError:@"请先登录" toView:self.view];
                return;
            }
            rootVC.title = @"我的收藏";
            rootVC.bottomBtnTitle = @"取消收藏";
            rootVC.projectType = 2;
            
            [self.navigationController pushViewController:rootVC animated:true];
        }
            break;
        case SearchBtnTag:
        {
            PGCSearchViewController *searchVC = [[PGCSearchViewController alloc] init];
            searchVC.searchData = self.dataSource;
            [self.navigationController pushViewController:searchVC animated:true];
        }
            break;
        default:
            break;
    }
}

- (void)deleteSearchTitleView:(UIButton *)sender
{
    [self animationWithTitle:nil forward:false];
}



#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isSearch ? self.searchDataSource.count : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectInfoCell];
    cell.project = _isSearch ? self.searchDataSource[indexPath.row] : self.dataSource[indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProject *projectInfo = _isSearch ? self.searchDataSource[indexPath.row] : self.dataSource[indexPath.row];
    // SDAutoLayout 的cell高度自适应
    return [tableView cellHeightForIndexPath:indexPath model:projectInfo keyPath:@"project" cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProject *projectInfo = _isSearch ? self.searchDataSource[indexPath.row] : self.dataSource[indexPath.row];
    PGCProjectDetailViewController *detailVC = [[PGCProjectDetailViewController alloc] init];
    detailVC.projectDetail = projectInfo;
    [self.navigationController pushViewController:detailVC animated:true];
}



#pragma mark -
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
        default: return _progressDatas.count;
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
            PGCProjectType *type = _typeDatas[indexPath.row];
            return type.name;
        }
            break;
        default:
        {
            PGCProjectProgress *progress = _progressDatas[indexPath.row];
            return progress.name;
        }
            break;
    }
}

- (NSInteger)menu:(DropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    switch (column) {
        case 0:
        {
            PGCProvince *province = _areaDatas[row];
            return province.cities.count;
        }
            break;
        case 1: return 0;
            break;
        default: return _progressDatas.count;
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
        case 1: return nil;
            break;
        default:
        {
            PGCProjectProgress *progress = _progressDatas[indexPath.row];
            return progress.name;
        }
            break;
    }
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    return column == 2 ? true : false;
}

//- (BOOL)haveRightTableViewInColumn:(NSInteger)column
//{
//    return column == 0 ? true : false;
//}
//
//- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
//{
//    return column == 0 ? 0.5 : 1;
//}
//
//- (NSInteger)currentLeftSelectedRow:(NSInteger)column
//{
//    switch (column) {
//        case 0: return _currentProvinceIndex; break;
//        case 1: return _currentTypeIndex; break;
//        default: return 0;  break;
//    }
//}
//
//- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
//{
//    switch (column) {
//        case 0:
//        {
//            if (leftOrRight == 0) {
//                return _areaDatas.count;
//            } else {
//                PGCProvince *province = _areaDatas[leftRow];
//                return province.cities.count;
//            }
//        }
//            break;
//        case 1: return _typeDatas.count; break;
//        default: return _progressDatas.count; break;
//    }
//}
//
//- (NSString *)menu:(DropDownMenu *)menu titleForColumn:(NSInteger)column
//{
//    switch (column) {
//        case 0: return @"地区"; break;
//        case 1: return @"类别"; break;
//        default: return @"阶段"; break;
//    }
//}
//
//- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(IndexPath *)indexPath
//{
//    switch (indexPath.column) {
//        case 0:
//        {
//            if (indexPath.leftOrRight == 0) {
//                PGCProvince *province = _areaDatas[indexPath.row];
//                return province.province;
//                
//            } else {
//                PGCProvince *province = _areaDatas[indexPath.leftRow];
//                PGCCity *city = province.cities[indexPath.row];
//                return city.city;
//            }
//        }
//            break;
//        case 1:
//        {
//            PGCProjectType *type = _typeDatas[indexPath.row];
//            return type.name;
//        }
//            break;
//        default:
//        {
//            PGCProjectProgress *progress = _progressDatas[indexPath.row];
//            return progress.name;
//        }
//            break;
//    }
//}


#pragma mark -
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
            
//            if (indexPath.leftOrRight == 0) {
//                _currentProvinceIndex = indexPath.row;
//                PGCProvince *province = _areaDatas[indexPath.row];
//                
//                if (!(province.cities.count > 0)) {
//                    [self.parameters setObject:@(province.id) forKey:@"province_id"];
//                }
//                
//            } else {
//                PGCProvince *province = _areaDatas[indexPath.leftRow];
//                PGCCity *city = province.cities[indexPath.row];
//                [self.parameters setObject:@(city.id) forKey:@"city_id"];
//            }
        }
            break;
        case 1:
        {
            _currentTypeIndex = indexPath.row;
            PGCProjectType *type = _typeDatas[indexPath.row];
            [self.parameters setObject:@(type.type_id) forKey:@"type_id"];
        }
            break;
        default:
        {
            _currentStageIndex = indexPath.row;
            PGCProjectProgress *progress = _progressDatas[indexPath.row];
            [self.parameters setObject:@(progress.progress_id) forKey:@"progress_id"];
        }
            break;
    }
    [self loadProjectData];
}


#pragma mark -
#pragma mark - Animation

- (void)animationWithTitle:(NSString *)title forward:(BOOL)forward
{
    if (forward) {
        UIView *view = [self searchTitleView:title];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(0, view.bottom_sd, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - view.bottom_sd);
        }];
    } else {
        CGRect frame = CGRectMake(0, self.menu.bottom_sd, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - self.menu.bottom_sd);
        _searchTitleView.frame = frame;
        self.tableView.frame = frame;
        
        [_searchTitleView removeFromSuperview];
        
        _isSearch = false;
        
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        } else {
            [self loadProjectData];
        }
    }
}


#pragma mark -
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


- (DropDownMenu *)menu {
    if (!_menu) {
        _menu = [[DropDownMenu alloc] initWithOrigin:CGPointMake(0, STATUS_AND_NAVIGATION_HEIGHT) andHeight:40];
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
        [_tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kProjectInfoCell];
        // 设置表格视图下拉刷新和上拉加载
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadProjectData)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.ignoredScrollViewContentInsetBottom = 0;
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
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

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

- (UIView *)searchTitleView:(NSString *)title
{
    if (!_searchTitleView) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, self.menu.bottom_sd, SCREEN_WIDTH, 40);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        _searchTitleView = view;
        
        CGFloat width = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width;
        width += 40;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.bounds = CGRectMake(0, 0, width, 30);
        titleLabel.center = CGPointMake(width / 2 + 15, view.height_sd / 2);
        titleLabel.layer.borderWidth = 0.5;
        titleLabel.layer.borderColor = PGCTintColor.CGColor;
        titleLabel.layer.cornerRadius = titleLabel.height_sd / 2;
        titleLabel.font = SetFont(14);
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [view addSubview:titleLabel];
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.bounds = CGRectMake(0, 0, 30, 30);
        deleteBtn.center = CGPointMake(view.width_sd - deleteBtn.width_sd / 2 - 20, view.height_sd / 2);
        deleteBtn.titleLabel.font = SetFont(14);
        [deleteBtn setImage:[UIImage imageNamed:@"delete_y"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteSearchTitleView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteBtn];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = PGCBackColor;
        line.frame = CGRectMake(0, view.height_sd - 1, view.width_sd, 1);
        [view addSubview:line];
    }
    return _searchTitleView;
}

@end
