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
#import "PGCRegisterOrLoginAPIManager.h"
#import "PGCProduct.h"
#import "PGCPayView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface PGCVIPServiceController () <UITableViewDataSource, UITableViewDelegate, PGCPayViewDelegate, PGCVIPServiceCellDelegate>

@property (copy, nonatomic) NSArray *dataSource;/** 表格视图数据源 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) NSMutableDictionary *params;/** 参数 */

- (void)initializeDataSource;/* 初始化数据源 */
- (void)initializeUserInterface;/* 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCVIPServiceController

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kVIP_WeChatPay object:nil];
    [PGCNotificationCenter removeObserver:self name:kVIP_Alipay object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeDataSource
{
    MBProgressHUD *hud = [PGCProgressHUD showProgress:nil toView:KeyWindow];
    [PGCVIPServiceAPIManager getVipProductListRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        [hud hideAnimated:true];
        
        if (status == RespondsStatusSuccess) {
            self.dataSource = resultData;
            
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

- (void)updateSession
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    NSDictionary *params = @{@"user_id":@(user.user_id),
                             @"client_type":@"iphone",
                             @"token":manager.token.token};
    // 更新用户session
    [PGCRegisterOrLoginAPIManager updateSessionRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            
        }
    }];
}


- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(weChatPay:) name:kVIP_WeChatPay object:nil];
    [PGCNotificationCenter addObserver:self selector:@selector(aliPay:) name:kVIP_Alipay object:nil];
}


- (void)weChatPay:(NSNotification *)notifi
{
    NSString *key = @"WeChatPay";
    if ([notifi.userInfo objectForKey:key]) {
        NSDictionary *result = [notifi.userInfo objectForKey:key];
        NSInteger resultStatus = [result[@"result"] integerValue];
        
        if (resultStatus == 1) {//支付成功
            PGCPayView *succeedView = [[PGCPayView alloc] initWithSuccessPay];
            [succeedView showPayViewWithGCD];
            [self updateSession];
            [PGCNotificationCenter postNotificationName:kReloadProjectsContact object:nil userInfo:nil];
        }
        else if (resultStatus == 0) {//用户取消了支付
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:result[@"message"] actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
            }];
        }
        else if (resultStatus == -1) {//支付失败
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:result[@"message"] actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
            }];
        }
    } else {
        [PGCProgressHUD showAlertWithTarget:self title:@"支付失败：" message:@"发生了未知错误" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
        }];
    }
}

- (void)aliPay:(NSNotification *)notifi
{
    NSString *key = @"AliPay";
    if ([notifi.userInfo objectForKey:key]) {
        NSDictionary *result = [notifi.userInfo objectForKey:key];
        NSInteger resultStatus = [result[@"resultStatus"] integerValue];
        
        if (resultStatus == 9000) {
            PGCPayView *succeedView = [[PGCPayView alloc] initWithSuccessPay];            
            [succeedView showPayViewWithGCD];
            [self updateSession];
            [PGCNotificationCenter postNotificationName:kReloadProjectsContact object:nil userInfo:nil];
        }
        else if (resultStatus == 4000) {
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"系统异常" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
            }];
        }
        else if (resultStatus == 6001) {
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"用户中途取消" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
            }];
        }
        else if (resultStatus == 6002) {
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"网络连接出错" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
            }];
        }
    } else {
        [PGCProgressHUD showAlertWithTarget:self title:@"支付失败：" message:@"发生了未知错误" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
        }];
    }
}


#pragma mark - PGCVIPServiceCellDelegate

- (void)vipServiceCell:(PGCVIPServiceCell *)cell payButton:(UIButton *)payButton
{
    PGCPayView *payView = [[PGCPayView alloc] init];
    payView.delegate = self;
    [payView showPayView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PGCProduct *product = _dataSource[indexPath.row];
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    [self.params setObject:@(user.user_id) forKey:@"user_id"];
    [self.params setObject:@"iphone" forKey:@"client_type"];
    [self.params setObject:manager.token.token forKey:@"token"];
    [self.params setObject:@(product.id) forKey:@"product_id"];
}


#pragma mark - PGCPayViewDelegate

- (void)payView:(PGCPayView *)payView weChat:(UIButton *)weChat
{
    [self.params setObject:@"weixinApp" forKey:@"pay_way"];
    
    MBProgressHUD *hud = [PGCProgressHUD showProgress:nil toView:self.view];
    
    [PGCVIPServiceAPIManager buyVipRequestWithParameters:self.params responds:^(RespondsStatus status, NSString *message, NSDictionary *resultData) {
        [hud hideAnimated:true];
        if (status == RespondsStatusSuccess) {
            //注册微信支付
            [WXApi registerApp:WeChat_APPID withDescription:@"com.leco.gcb.project.user"];
            //调起微信支付
            PayReq *req     = [[PayReq alloc] init];
            req.partnerId   = [resultData objectForKey:@"partnerId"];
            req.prepayId    = [resultData objectForKey:@"prepayId"];
            req.nonceStr    = [resultData objectForKey:@"nonceStr"];
            req.timeStamp   = [[resultData objectForKey:@"timeStamp"] intValue];
            req.package     = [resultData objectForKey:@"packageValue"];
            req.sign        = [resultData objectForKey:@"sign"];
            //发送请求到微信，等待微信返回onResp
            [WXApi sendReq:req];
        }
    }];
}

- (void)payView:(PGCPayView *)payView alipay:(UIButton *)alipay
{
    [self.params setObject:@"alipay" forKey:@"pay_way"];
    
    MBProgressHUD *hud = [PGCProgressHUD showProgress:nil toView:self.view];
    
    [PGCVIPServiceAPIManager buyVipRequestWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [hud hideAnimated:true];
        if (status == RespondsStatusSuccess) {
            [[AlipaySDK defaultService] payOrder:resultData fromScheme:@"alisdkzbapp" callback:^(NSDictionary *resultDic) {
                //TODO: NSLog(@"%@", resultDic);
            }];
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCVIPServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kVIPServiceCell];
    cell.product = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProduct *product = self.dataSource[indexPath.row];
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
    }
    return _params;
}

@end
