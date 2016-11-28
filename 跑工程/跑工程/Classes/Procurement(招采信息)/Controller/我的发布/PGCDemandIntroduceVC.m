//
//  PGCDemandIntroduceVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandIntroduceVC.h"
#import "PGCProcurementCell.h"
#import "PGCDemandIntroduceInfoVC.h"
#import "PGCDemandAPIManager.h"
#import "PGCDemand.h"

@interface PGCDemandIntroduceVC () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _page;/** 查询第一页 */
    NSInteger _pageSize;/** 查询页数 */
}
@property (strong, nonatomic) UIView *bottomView;/** 底部是否删除的选择视图 */
@property (strong, nonatomic) UIButton *editBtn;/** 编辑按钮 */
@property (strong, nonatomic) NSMutableDictionary *params;/** 查询参数 */
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;/** 数据源 */
@property (strong, nonatomic) NSMutableArray *deleteData;/** 需要删除的数据源 */

- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCDemandIntroduceVC

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kProcurementInfoData object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.title = @"我的发布";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self barButtonItem]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.editBtn];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(loadDemandIntroduce) name:kProcurementInfoData object:nil];
}


#pragma mark - Table Refresh

- (void)loadDemandIntroduce
{
    _page = 1;
    _pageSize = 10;
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(_pageSize) forKey:@"page_size"];
    
    [PGCDemandAPIManager myDemandsWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            [self.dataSource removeAllObjects];
            
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

- (void)loadMoreDemandIntroduce
{
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(1) forKey:@"page_size"];
    
    [PGCDemandAPIManager myDemandsWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
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


#pragma mark - Events

- (void)introduceDemandInfo:(UIButton *)sender
{
    PGCDemandIntroduceInfoVC *infoVC = [[PGCDemandIntroduceInfoVC alloc] init];
    [self.navigationController pushViewController:infoVC animated:true];
}

- (void)respondsToEdit:(UIButton *)sender
{
    [self.tableView setEditing:true animated:false];
    [self animateBottomView:self.bottomView show:true complete:^{
        
    }];
}

- (void)respondsToDelete:(UIButton *)sender
{
    if (!(self.deleteData.count > 0)) {
        [MBProgressHUD showError:@"请先选择需要删除的项目！" toView:self.view];
        return;
    }
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    NSMutableArray *array = [NSMutableArray array];
    for (PGCDemand *demand in self.deleteData) {
        [array addObject:@(demand.id)];
    }
    
    __weak __typeof(self) weakSelf = self;
    [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"是否确定删除需求？" actionTitle:@"确定" otherActionTitle:@"取消" handler:^(UIAlertAction *action) {
        
        MBProgressHUD *hud = [PGCProgressHUD showProgress:nil toView:self.view];
        NSDictionary *params = @{@"user_id":@(user.user_id),
                                 @"client_type":@"iphone",
                                 @"token":manager.token.token,
                                 @"ids_json":[array mj_JSONString]};
        [PGCDemandAPIManager deleteMyDemandsWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                [self.dataSource removeObjectsInArray:self.deleteData];
                [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationLeft];
                [self.deleteData removeAllObjects];
                [self.tableView.mj_header beginRefreshing];
                [PGCNotificationCenter postNotificationName:kProcurementInfoData object:nil userInfo:nil];
                [weakSelf respondsToCancel:nil];
            }
        }];
    } otherHandler:^(UIAlertAction *action) {
        [self.deleteData removeAllObjects];
    }];
}

- (void)respondsToCancel:(UIButton *)sender
{
    [self.tableView setEditing:false animated:false];
    [self animateBottomView:self.bottomView show:false complete:^{
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProcurementCell *cell = [tableView dequeueReusableCellWithIdentifier:kProcurementCell];
    cell.demand = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCDemand *demand = self.dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:demand keyPath:@"demand" cellClass:[PGCProcurementCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.deleteData addObject:self.dataSource[indexPath.row]];
        return;
    }
    PGCDemand *demand = self.dataSource[indexPath.row];
    PGCDemandIntroduceInfoVC *detailVC = [[PGCDemandIntroduceInfoVC alloc] init];
    detailVC.demandDetail = demand;
    [self.navigationController pushViewController:detailVC animated:true];
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
            [self.view addSubview:bottomView];
            bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
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
    button.bounds = CGRectMake(0, 0, 80, 40);
    [button setImage:[UIImage imageNamed:@"发布信息"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:@"发布信息" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(introduceDemandInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    
    return button;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCProcurementCell class] forCellReuseIdentifier:kProcurementCell];
        // 设置表格视图下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDemandIntroduce)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDemandIntroduce)];
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


- (NSMutableArray *)deleteData {
    if (!_deleteData) {
        _deleteData = [NSMutableArray array];
    }
    return _deleteData;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
        
        PGCManager *manager = [PGCManager manager];
        [manager readTokenData];
        PGCUser *user = manager.token.user;
        
        [_params setObject:@(user.user_id) forKey:@"user_id"];
        [_params setObject:@"iphone" forKey:@"client_type"];
        [_params setObject:manager.token.token forKey:@"token"];
    }
    return _params;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width_sd / 2, _bottomView.height_sd)];
        delete.backgroundColor = PGCTintColor;
        [delete setTitle:@"删除" forState:UIControlStateNormal];
        [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(respondsToDelete:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:delete];
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(delete.right_sd, 0, _bottomView.width_sd / 2, _bottomView.height_sd)];
        cancel.backgroundColor = [UIColor whiteColor];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:PGCTextColor forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(respondsToCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancel];
    }
    return _bottomView;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        _editBtn.backgroundColor = PGCTintColor;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(respondsToEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}


@end
