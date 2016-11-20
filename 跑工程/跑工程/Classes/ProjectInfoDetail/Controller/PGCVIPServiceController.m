//
//  PGCVIPServiceController.m
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCVIPServiceController.h"
#import "PGCVIPServiceCell.h"
#import "PGCPayView.h"

@interface PGCVIPServiceController () <UITableViewDataSource, UITableViewDelegate, PGCPayViewDelegate, PGCVIPServiceCellDelegate>

@property (copy, nonatomic) NSArray *dataSource;/** 表格视图数据源 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */

- (void)initializeDataSource;/* 初始化数据源 */
- (void)initializeUserInterface;/* 初始化用户界面 */

@end

@implementation PGCVIPServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    _dataSource = @[@"1、开通会员服务后，使用有效期为一年", @"2、相关的规则和说明", @"3、相关的服务和说明"];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"开通服务";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    
    // 服务说明的底部视图
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(50);
    
    /* tips标签 */
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = RGB(204, 204, 204);
    tipsLabel.text = @"如有疑问，请联系我们。";
    tipsLabel.font = SetFont(15);
    [bottomView addSubview:tipsLabel];
    tipsLabel.sd_layout
    .topSpaceToView(bottomView, 5)
    .leftSpaceToView(bottomView, 15)
    .rightSpaceToView(bottomView, 15)
    .autoHeightRatio(0);
    
    /* 电话号码标签 */
    UILabel *phoneNumberLabel = [[UILabel alloc] init];
    phoneNumberLabel.textColor = PGCTintColor;
    phoneNumberLabel.font = SetFont(14);
    phoneNumberLabel.text = @"023-xxxxxxxx";
    [bottomView addSubview:phoneNumberLabel];
    phoneNumberLabel.sd_layout
    .bottomSpaceToView(bottomView, 5)
    .leftSpaceToView(bottomView, 15)
    .rightSpaceToView(bottomView, 15)
    .autoHeightRatio(0);
}


#pragma mark - PGCVIPServiceCellDelegate

- (void)vipServiceCell:(PGCVIPServiceCell *)cell payButton:(UIButton *)payButton
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld-%ld", indexPath.section, indexPath.row);
    
    PGCPayView *payView = [[PGCPayView alloc] init];
    payView.delegate = self;
    [payView showPayView];
}


#pragma mark - PGCPayViewDelegate

- (void)payView:(PGCPayView *)payView weChat:(UIButton *)weChat
{
    PGCPayView *succeedView = [[PGCPayView alloc] initWithSuccessPay];
    [succeedView showPayViewWithGCD];
}

- (void)payView:(PGCPayView *)payView alipay:(UIButton *)alipay
{
    PGCPayView *succeedView = [[PGCPayView alloc] initWithSuccessPay];
    [succeedView showPayViewWithGCD];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCVIPServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kVIPServiceCell];
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:self.tableView];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, self.view.height_sd - STATUS_AND_NAVIGATION_HEIGHT - 60) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(244, 244, 244);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCVIPServiceCell class] forCellReuseIdentifier:kVIPServiceCell];
    }
    return _tableView;
}

@end
