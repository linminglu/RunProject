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
#import "PGCRecordViewController.h"
#import "PGCCollectViewController.h"
#import "PGCProjectInfoDetailViewController.h"
#import "JSDropDownMenu.h"
#import "PGCProvince.h"
#import "PGCProjectType.h"
#import "PGCProjectProgress.h"
#import "PGCProjectInfoAPIManager.h"
#import "PGCProjectInfo.h"

@interface PGCProjectInfoController () <UITableViewDataSource, UITableViewDelegate, JSDropDownMenuDataSource, JSDropDownMenuDelegate, PGCProjectInfoNavigationBarDelegate>
{
    NSArray *_areaDatas;
    NSArray *_typeDatas;
    NSArray *_stageDatas;
    
    NSInteger _currentAreaIndex;
    NSInteger _currenttypeIndex;
    NSInteger _currentstageIndex;
}

@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 表格数据源 */
@property (assign, nonatomic) int page;/** 查询页数 */
@property (assign, nonatomic) int pageSize;/** 查询最大页数 */

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

- (void)initializeDataSource {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    _areaDatas = [PGCProvince province].areaArray;
    _typeDatas = [PGCProjectType projectType].projectTypes;
    _stageDatas = [PGCProjectProgress projectProgress].progressArray;
    
    [PGCProjectInfoAPIManager getProjectsRequestWithParameters:@{@"page":@(1), @"page_size":@(20)} responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            
            NSArray *resultArray = resultData[@"result"];
            
            NSLog(@"%@", PGCCachesPath);
            
            for (id value in resultArray) {
                PGCProjectInfo *project = [PGCProjectInfo mj_objectWithKeyValues:value];
                
                [self.dataSource addObject:project];
            }
            if (self.dataSource.count > 20) {
                self.tableView.mj_footer.hidden = false;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 自定义导航栏
    PGCProjectInfoNavigationBar *navigationBar = [[PGCProjectInfoNavigationBar alloc] init];
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
    
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, navigationBar.bottom) andHeight:40];
    menu.backgroundColor = [UIColor whiteColor];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    // 表格视图
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kProjectInfoCell];
    // 设置表格视图下拉刷新和上拉加载
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadProjectData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    tableView.mj_footer.automaticallyHidden = true;
    [self.view addSubview:tableView];
    // 开始自动布局
    tableView.sd_layout
    .topSpaceToView(menu, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, TAB_BAR_HEIGHT);
    
    self.tableView = tableView;
}



#pragma mark - 
#pragma mark - 加载数据

- (void)loadProjectData {
    [self.dataSource removeAllObjects];
    
    [PGCProjectInfoAPIManager getProjectsRequestWithParameters:@{@"page":@(1), @"page_size":@(20)} responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            
            NSArray *resultArray = resultData[@"result"];
            
            for (id value in resultArray) {
                PGCProjectInfo *project = [PGCProjectInfo mj_objectWithKeyValues:value];
                [self.dataSource addObject:project];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectInfoCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadProjectWithModel:self.dataSource[indexPath.row]];
    
    return cell;
}



#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PGCProjectInfoDetailViewController *detailVC = [[PGCProjectInfoDetailViewController alloc] init];
    
    detailVC.projectInfoDetail = self.dataSource[indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:true];
}



#pragma mark -
#pragma mark - PGCProjectInfoNavigationBarDelegate

- (void)projectInfoNavigationBar:(PGCProjectInfoNavigationBar *)projectInfoNavigationBar tapItem:(NSInteger)tag {
    switch (tag) {
        case mapItemTag:
        {
            [self.navigationController pushViewController:[PGCMapTypeViewController new] animated:true];
        }
            break;
        case recordItemTag:
        {
            [self.navigationController pushViewController:[PGCRecordViewController new] animated:true];
        }
            break;
        case collectItemTag:
        {
            [self.navigationController pushViewController:[PGCCollectViewController new] animated:true];
        }
            break;
        case searchItemTag:
        {
            NSLog(@"搜索");
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark - PGCDropMenuDaJSDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    if (column == 2) {
        return true;
    }
    return false;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column {
    
    if (column == 0) {
        return true;
    }
    return false;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column {
    
    if (column == 0) {
        return 0.5;
    }
    return 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column {
    
    if (column==0) {
        
        return _currentAreaIndex;
        
    }
    if (column==1) {
        
        return _currenttypeIndex;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _areaDatas.count;
        } else{
            PGCProvince *province = _areaDatas[leftRow];
            NSArray *arr = province.city;
            
            return arr.count;
        }
    }
    else if (column==1) {
        
        return _typeDatas.count;
    }
    else if (column==2) {
        
        return _stageDatas.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return @"地区";
            break;
        case 1: return @"类别";
            break;
        case 2: return @"阶段";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            PGCProvince *province = _areaDatas[indexPath.row];
            
            return province.province;
            
        } else {
            PGCProvince *province = _areaDatas[indexPath.leftRow];
            NSArray *rightArr = province.city;
            PGCCity *city = rightArr[indexPath.row];
            
            return city.city;
        }
    }
    else if (indexPath.column==1) {
        PGCProjectType *type = _typeDatas[indexPath.row];
        
        return type.name;
    }
    else {
        PGCProjectProgress *progress = _stageDatas[indexPath.row];
        
        return progress.name;
    }
}


#pragma mark -
#pragma mark - JSDropDownMenuDelegatetaSource

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.leftOrRight == 0) {
            
            _currentAreaIndex = indexPath.row;
            
            return;
        }
    }
    else if (indexPath.column == 1) {
        
        _currenttypeIndex = indexPath.row;
    }
    else{
        _currentstageIndex = indexPath.row;
    }
}



#pragma mark -
#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
