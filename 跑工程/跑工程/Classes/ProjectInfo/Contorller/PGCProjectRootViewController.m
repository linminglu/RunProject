//
//  PGCProjectRootViewController.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectRootViewController.h"
#import "PGCProjectInfoCell.h"
#import "PGCProjectInfoDetailVC.h"
#import "PGCProjectInfoAPIManager.h"
#import "PGCProjectInfo.h"

static NSString * const kProjectRootCell = @"ProjectRootCell";

@interface PGCProjectRootViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
}
@property (strong, nonatomic) UIView *bottomView;/** 底部是否删除的选择视图 */
@property (strong, nonatomic) NSMutableDictionary *params;/** 查询参数 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableArray<PGCProjectInfo *> *dataSources;/** 数据源 */
@property (strong, nonatomic) NSMutableArray<PGCProjectInfo *> *deleteData;/** 需要删除的数据源 */

- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCProjectRootViewController

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kRefreshCollectTable object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self barButtonItem]];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(loadCollectData) name:kRefreshCollectTable object:nil];
}


#pragma mark - 表格刷新数据

- (void)loadCollectData
{
    _page = 1;
    _pageSize = 10;
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(_pageSize) forKey:@"page_size"];
    
    [PGCProjectInfoAPIManager getAccessOrCollectRequestWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            [self.dataSources removeAllObjects];
            
            for (id value in resultData[@"result"]) {
                PGCProjectInfo *model = [[PGCProjectInfo alloc] init];
                [model mj_setKeyValues:value];
                [self.dataSources addObject:model];
            }
            _page += 10;
            [self.tableView reloadData];
        }
    }];
}


- (void)loadMoreCollectData
{
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(1) forKey:@"page_size"];
    
    [PGCProjectInfoAPIManager getAccessOrCollectRequestWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            NSArray *resultArray = resultData[@"result"];
            if (resultArray.count > 0) {
                for (id value in resultArray) {
                    PGCProjectInfo *model = [[PGCProjectInfo alloc] init];
                    [model mj_setKeyValues:value];
                    [self.dataSources addObject:model];
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

- (void)respondsToEdit:(UIButton *)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:true];
    [self animateBottomView:self.bottomView show:self.tableView.editing complete:^{
        
    }];
}

- (void)respondsToCancel:(UIButton *)sender
{
    [self.tableView setEditing:false animated:true];
    [self animateBottomView:self.bottomView show:false complete:^{
        
    }];
}

- (void)respondsToDelete:(UIButton *)sender
{
    if (!(self.deleteData.count > 0)) {
        [PGCProgressHUD showMessage:@"请先选择需要删除的项目！" toView:self.view];
        return;
    }
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    NSMutableArray *array = [NSMutableArray array];
    for (PGCProjectInfo *project in self.deleteData) {
        [array addObject:@(project.collect_id)];
    }
    NSString *ids_json = [PGCBaseAPIManager jsonToString:array];
    NSString *string = [NSString stringWithFormat:@"是否确定%@?", _bottomBtnTitle];
    
    __weak __typeof(self) weakSelf = self;
    [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:string actionTitle:@"确定" otherActionTitle:@"取消" handler:^(UIAlertAction *action) {
        
        MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:nil];
        NSDictionary *params = @{@"user_id":@(user.user_id),
                                 @"client_type":@"iphone",
                                 @"token":manager.token.token,
                                 @"ids_json":ids_json};
        [PGCProjectInfoAPIManager deleteAccessOrCollectRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            if (status == RespondsStatusSuccess) {
                [self.dataSources removeObjectsInArray:self.deleteData];
                [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationLeft];
                [self.deleteData removeAllObjects];
                [self.tableView reloadData];
                
                [PGCNotificationCenter postNotificationName:kRefreshCollectTable object:nil userInfo:nil];
                [weakSelf respondsToCancel:nil];
            }
        }];
    } otherHandler:^(UIAlertAction *action) {
        [self.deleteData removeAllObjects];
    }];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectRootCell forIndexPath:indexPath];
    cell.project = self.dataSources[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfo *projectInfo = self.dataSources[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:projectInfo keyPath:@"project" cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.deleteData addObject:self.dataSources[indexPath.row]];
        return;
    }
    PGCProjectInfo *projectInfo = self.dataSources[indexPath.row];
    PGCProjectInfoDetailVC *detailVC = [[PGCProjectInfoDetailVC alloc] init];
    detailVC.projectInfoDetail = projectInfo;
    [self.navigationController pushViewController:detailVC animated:true];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.deleteData removeObject:self.dataSources[indexPath.row]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - Animation

- (void)animateBottomView:(UIView *)bottomView show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, self.view.height_sd - TAB_BAR_HEIGHT, self.view.width_sd, TAB_BAR_HEIGHT);
            [self.view addSubview:bottomView];
            
            self.tableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, self.view.height_sd - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, self.view.height_sd, self.view.width_sd, TAB_BAR_HEIGHT);
            
            self.tableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, self.view.height_sd - STATUS_AND_NAVIGATION_HEIGHT);
        } completion:^(BOOL finished) {
            [bottomView removeFromSuperview];
            [self.deleteData removeAllObjects];
        }];
    }
    complete();
}


#pragma mark - Setter

- (void)setProjectType:(int)projectType
{
    _projectType = projectType;
    
    _page = 1;
    _pageSize = 10;
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    [self.params setObject:@(user.user_id) forKey:@"user_id"];
    [self.params setObject:@"iphone" forKey:@"client_type"];
    [self.params setObject:manager.token.token forKey:@"token"];
    [self.params setObject:@(projectType) forKey:@"type"];
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(_pageSize) forKey:@"page_size"];
}


#pragma mark - Getter

- (UIButton *)barButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 55, 40);
    [button setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelInset = [button.titleLabel intrinsicContentSize].width - button.imageView.width - button.width;
    CGFloat imageInset = button.imageView.width - button.width - button.titleLabel.width;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    return button;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, self.view.height_sd - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kProjectRootCell];
        // 设置表格视图下拉刷新和上拉加载
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCollectData)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCollectData)];
        footer.ignoredScrollViewContentInsetBottom = 0;
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (NSMutableArray<PGCProjectInfo *> *)dataSources
{
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (NSMutableArray<PGCProjectInfo *> *)deleteData
{
    if (!_deleteData) {
        _deleteData = [NSMutableArray array];
    }
    return _deleteData;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height_sd, self.view.width_sd, TAB_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width / 2, _bottomView.height)];
        delete.backgroundColor = PGCTintColor;
        [delete setTitle:_bottomBtnTitle forState:UIControlStateNormal];
        [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(respondsToDelete:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:delete];
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(delete.right, 0, _bottomView.width / 2, _bottomView.height)];
        cancel.backgroundColor = [UIColor whiteColor];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:PGCTextColor forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(respondsToCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancel];
    }
    return _bottomView;
}

@end
