//
//  PGCVIPServiceController.m
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCVIPServiceController.h"
#import "PGCVIPServiceCell.h"
#import "PGCVIPServiceAPIManager.h"
#import "PGCProduct.h"
#import "PGCPayView.h"
#import "WXApiManager.h"

@interface PGCVIPServiceController () <UITableViewDataSource, UITableViewDelegate, PGCPayViewDelegate, PGCVIPServiceCellDelegate>

@property (copy, nonatomic) NSArray *dataSource;/** 表格视图数据源 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableDictionary *params;/** 参数 */

- (void)initializeDataSource;/* 初始化数据源 */
- (void)initializeUserInterface;/* 初始化用户界面 */

@end

@implementation PGCVIPServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource
{
    [PGCVIPServiceAPIManager getVipProductListRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        if (status == RespondsStatusSuccess) {
            
            _dataSource = resultData;
            [self.tableView reloadData];
        }
    }];
}

- (void)initializeUserInterface
{
    self.title = @"开通服务";
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
    PGCPayView *payView = [[PGCPayView alloc] init];
    payView.delegate = self;
    [payView showPayView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PGCProduct *product = _dataSource[indexPath.row];
    
    [self.params setObject:@(product.id) forKey:@"product_id"];
}


#pragma mark - PGCPayViewDelegate

- (void)payView:(PGCPayView *)payView weChat:(UIButton *)weChat
{
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = @"";
    
    // 商家id，在注册的时候给的
    req.partnerId = @"";
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId = @"";
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package = @"";
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr = @"";
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString *stamp = @"";
    req.timeStamp = [stamp intValue];
    
    // 这个签名也是后台做的
    req.sign = @"";
    
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
    
    
    
    [self.params setObject:@"weixinApp" forKey:@"pay_way"];
    [PGCVIPServiceAPIManager buyVipRequestWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        
    }];
    
    PGCPayView *succeedView = [[PGCPayView alloc] initWithSuccessPay];
    [succeedView showPayViewWithGCD];
}

- (void)payView:(PGCPayView *)payView alipay:(UIButton *)alipay
{
    [self.params setObject:@"alipay" forKey:@"pay_way"];    
    [PGCVIPServiceAPIManager buyVipRequestWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        
    }];
    
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
    cell.product = _dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProduct *product = _dataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:product keyPath:@"product" cellClass:[PGCVIPServiceCell class] contentViewWidth:SCREEN_WIDTH];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, self.view.height_sd - STATUS_AND_NAVIGATION_HEIGHT - 50) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCVIPServiceCell class] forCellReuseIdentifier:kVIPServiceCell];
    }
    return _tableView;
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
@end
