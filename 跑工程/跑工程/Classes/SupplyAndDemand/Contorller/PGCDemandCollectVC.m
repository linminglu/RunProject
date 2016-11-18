//
//  PGCDemandCollectVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandCollectVC.h"
#import "PGCSupplyAndDemandCell.h"
#import "PGCDemandDetailVC.h"
#import "PGCSupplyAndDemandAPIManager.h"
#import "PGCDemand.h"

@interface PGCDemandCollectVC () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
}
@property (strong, nonatomic) NSMutableDictionary *params;/** 查询参数 */
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *dataSource;/** 数据源 */
@property (strong, nonatomic) NSMutableArray *deleteData;/** 需要删除的数据源 */

- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCDemandCollectVC

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kRefreshDemandAndSupplyData object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self barButtonItem]];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(loadDemandCollect) name:kRefreshDemandAndSupplyData object:nil];
}



#pragma mark - Table Refresh

- (void)loadDemandCollect
{
    [self.dataSource removeAllObjects];
    _page = 1;
    _pageSize = 10;
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(_pageSize) forKey:@"page_size"];
    
    [PGCSupplyAndDemandAPIManager getSupplyDemandCollectWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            for (id value in resultData[@"result"]) {
                PGCDemand *model = [[PGCDemand alloc] init];
                [model mj_setKeyValues:value];
                [self.dataSource addObject:model];
            }
            _page += 10;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreDemandCollect
{
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(1) forKey:@"page_size"];
    
    [PGCSupplyAndDemandAPIManager getSupplyDemandCollectWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            NSArray *resultArray = resultData[@"result"];
            if (resultArray.count > 0) {
                for (id value in resultArray) {
                    PGCDemand *model = [[PGCDemand alloc] init];
                    [model mj_setKeyValues:value];
                    [self.dataSource addObject:model];
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

- (void)respondsToCollectEdit:(UIBarButtonItem *)sender
{
    self.tableView.editing = !self.tableView.editing;
    [self animateBottomView:self.bottomView show:self.tableView.editing complete:^{
        
    }];
}

- (void)respondsToCancel:(UIButton *)sender {
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
    for (PGCDemand *demand in self.deleteData) {
        [array addObject:@(demand.collect_id)];
    }
    NSString *ids_json = [PGCBaseAPIManager jsonToString:array];
    
    __weak __typeof(self) weakSelf = self;
    [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"是否确定删除收藏？" actionTitle:@"确定" otherActionTitle:@"取消" handler:^(UIAlertAction *action) {
        
        MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:nil];
        NSDictionary *params = @{@"user_id":@(user.user_id),
                                 @"client_type":@"iphone",
                                 @"token":manager.token.token,
                                 @"ids_json":ids_json};
        [PGCSupplyAndDemandAPIManager deleteSupplyDemandCollectWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                // 这里传self.deleteData.lastObject，只是为了传一个 PGCDemand 的对象
                [PGCNotificationCenter postNotificationName:kRefreshDemandAndSupplyData object:self.deleteData.lastObject userInfo:nil];
                
                [self.dataSource removeObjectsInArray:self.deleteData];
                [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView reloadData];
                [self.deleteData removeAllObjects];
                
                [weakSelf respondsToCancel:nil];
            }
        }];
    } otherHandler:^(UIAlertAction *action) {
        [self.deleteData removeAllObjects];
    }];
}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupplyAndDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyAndDemandCell];
    cell.demand = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCDemand *demand = self.dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:demand keyPath:@"demand" cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.deleteData addObject:self.dataSource[indexPath.row]];
        
    } else {
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:false animated:true];
        
        PGCDemand *demand = self.dataSource[indexPath.row];
        PGCDemandDetailVC *detailVC = [[PGCDemandDetailVC alloc] init];
        detailVC.demand = demand;
        [self.navigationController pushViewController:detailVC animated:true];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.deleteData removeObject:self.dataSource[indexPath.row]];
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


#pragma mark - Getter

- (UIButton *)barButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 55, 40);
    [button setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToCollectEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelInset = [button.titleLabel intrinsicContentSize].width - button.imageView.width - button.width;
    CGFloat imageInset = button.imageView.width - button.width - button.titleLabel.width;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    return button;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(244, 244, 244);
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
        // 设置表格视图下拉刷新和上拉加载
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDemandCollect)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDemandCollect)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        footer.ignoredScrollViewContentInsetBottom = 30;
        _tableView.mj_footer = footer;
    }
    return _tableView;
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width / 2, _bottomView.height)];
        delete.backgroundColor = PGCTintColor;
        [delete setTitle:@"删除" forState:UIControlStateNormal];
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)deleteData {
    if (!_deleteData) {
        _deleteData = [NSMutableArray array];
    }
    return _deleteData;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
        
        _page = 1;
        _pageSize = 10;
        
        PGCManager *manager = [PGCManager manager];
        [manager readTokenData];
        PGCUser *user = manager.token.user;
        
        [_params setObject:@(user.user_id) forKey:@"user_id"];
        [_params setObject:@"iphone" forKey:@"client_type"];
        [_params setObject:manager.token.token forKey:@"token"];
        [_params setObject:@(2) forKey:@"type"];
        [_params setObject:@(_page) forKey:@"page"];
        [_params setObject:@(_pageSize) forKey:@"page_size"];
    }
    return _params;
}

@end
