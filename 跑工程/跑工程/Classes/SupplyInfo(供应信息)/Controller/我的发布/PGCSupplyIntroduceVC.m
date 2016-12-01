//
//  PGCSupplyIntroduceVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyIntroduceVC.h"
#import "PGCSupplyInfoCell.h"
#import "PGCSupplyIntroduceInfoVC.h"
#import "PGCSupplyAPIManager.h"
#import "PGCSupply.h"

@interface PGCSupplyIntroduceVC () <UITableViewDataSource, UITableViewDelegate>
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

@implementation PGCSupplyIntroduceVC

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kSupplyInfoData object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeUserInterface
{
    self.title = @"我的发布";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.editBtn];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(loadSupplyIntroduce) name:kSupplyInfoData object:nil];
}


#pragma mark - Table Refresh

- (void)loadSupplyIntroduce
{
    _page = 1;
    _pageSize = 10;
    [self.params setObject:@(_page) forKey:@"page"];
    [self.params setObject:@(_pageSize) forKey:@"page_size"];
    
    [PGCSupplyAPIManager mySuppliesWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [self.tableView.mj_header endRefreshing];
        
        if (status == RespondsStatusSuccess) {
            [self.dataSource removeAllObjects];
            
            for (id value in resultData[@"result"]) {
                PGCSupply *model = [[PGCSupply alloc] init];
                [model mj_setKeyValues:value];
                [self.dataSource addObject:model];
            }
            if (self.dataSource.count < 1) {
                self.navigationItem.rightBarButtonItem = [self barButtonItem];
            } else {
                self.navigationItem.rightBarButtonItem = nil;
            }
            _page += 10;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Events

- (void)introduceSupplyInfo:(UIButton *)sender
{
    PGCSupplyIntroduceInfoVC *infoVC = [[PGCSupplyIntroduceInfoVC alloc] init];
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
        [MBProgressHUD showError:@"请先选择需要关闭的项目！" toView:self.view];
        return;
    }
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    PGCSupply *supply = self.deleteData.firstObject;
    
    __weak __typeof(self) weakSelf = self;
    [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"是否确定关闭供应？" actionTitle:@"确定" otherActionTitle:@"取消" handler:^(UIAlertAction *action) {
        
        MBProgressHUD *hud = [PGCProgressHUD showProgress:nil toView:self.view];
        NSDictionary *params = @{@"user_id":@(user.user_id),
                                 @"client_type":@"iphone",
                                 @"token":manager.token.token,
                                 @"id":@(supply.id)};
        [PGCSupplyAPIManager closeMySupplyWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                [PGCNotificationCenter postNotificationName:kSupplyInfoData object:nil userInfo:nil];
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
    PGCSupplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyInfoCell];
    cell.supply = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCSupply *supply = self.dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:supply keyPath:@"supply" cellClass:[PGCSupplyInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        [self.deleteData addObject:self.dataSource[indexPath.row]];
        return;
    }
    PGCSupply *supply = self.dataSource[indexPath.row];
    PGCSupplyIntroduceInfoVC *detailVC = [PGCSupplyIntroduceInfoVC new];
    detailVC.supplyDetail = supply;
    [self.navigationController pushViewController:detailVC animated:true];
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

- (UIBarButtonItem *)barButtonItem
{
    UIImage *image = [UIImage imageNamed:@"发布加号"];
    NSString *title = @"发布信息";
    
    CGSize titleSize = [title sizeWithFont:SetFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    CGFloat width = image.size.width + titleSize.width + 10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, width, 40);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button.titleLabel setFont:SetFont(15)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(introduceSupplyInfo:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCSupplyInfoCell class] forCellReuseIdentifier:kSupplyInfoCell];
        // 设置表格视图下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSupplyIntroduce)];
        header.automaticallyChangeAlpha = true;
        header.lastUpdatedTimeLabel.hidden = true;
        _tableView.mj_header = header;
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
        [delete setTitle:@"关闭" forState:UIControlStateNormal];
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
