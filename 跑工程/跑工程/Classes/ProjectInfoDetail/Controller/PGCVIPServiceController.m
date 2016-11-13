//
//  PGCVIPServiceController.m
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCVIPServiceController.h"
#import "PGCPayView.h"

@interface PGCVIPServiceController () <UITableViewDataSource, PGCPayViewDelegate>

/**
 表格视图数据源
 */
@property (copy, nonatomic) NSArray *dataSource;
/**
 初始化数据源
 */
- (void)initializeDataSource;
/**
 初始化用户界面
 */
- (void)initializeUserInterface;

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

- (void)initializeUserInterface {
    self.navigationItem.title = @"开通服务";
    self.view.backgroundColor = RGB(244, 244, 244);
    
    // 会员开通服务费标签的底部视图
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    topView.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(50);
    
    NSString *textStr = @"会员开通服务费用：";
    // 会员开通服务费标签
    UILabel *label = [[UILabel alloc] init];
    label.textColor = PGCTextColor;
    label.font = SetFont(16);
    label.text = [textStr stringByAppendingString:@"¥xxx"];
    [topView addSubview:label];
    label.sd_layout
    .centerYEqualToView(topView)
    .leftSpaceToView(topView, 15)
    .rightSpaceToView(topView, 15)
    .autoHeightRatio(0);
    
    // 服务说明的底部视图
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerView];
    centerView.sd_layout
    .topSpaceToView(topView, 1)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(50);
    
    /* 服务说明标签 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = PGCTextColor;
    titleLabel.font = SetFont(15);
    titleLabel.text = @"服务说明：";
    [centerView addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(centerView, 10)
    .leftSpaceToView(centerView, 15)
    .rightSpaceToView(centerView, 15)
    .autoHeightRatio(0);
    
    /* 服务内容视图 */
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.rowHeight = 40;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = false;
    tableView.dataSource = self;
    [centerView addSubview:tableView];
    tableView.sd_layout
    .topSpaceToView(titleLabel, 10)
    .leftSpaceToView(centerView, 0)
    .rightSpaceToView(centerView, 0)
    .heightIs(40 * 3);
    
    /* tips标签 */
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = RGB(204, 204, 204);
    tipsLabel.text = @"如有疑问，请联系我们。";
    tipsLabel.font = SetFont(15);
    [centerView addSubview:tipsLabel];
    tipsLabel.sd_layout
    .topSpaceToView(tableView, 10)
    .leftSpaceToView(centerView, 15)
    .rightSpaceToView(centerView, 15)
    .autoHeightRatio(0);
    
    /* 电话号码标签 */
    UILabel *phoneNumberLabel = [[UILabel alloc] init];
    phoneNumberLabel.textColor = PGCTintColor;
    phoneNumberLabel.font = SetFont(15);
    phoneNumberLabel.text = @"023-xxxxxxxx";
    [centerView addSubview:phoneNumberLabel];
    phoneNumberLabel.sd_layout
    .topSpaceToView(tipsLabel, 15)
    .leftSpaceToView(centerView, 15)
    .rightSpaceToView(centerView, 15)
    .autoHeightRatio(0);
    
    [centerView setupAutoHeightWithBottomView:phoneNumberLabel bottomMargin:20];
        
    // 立即支付按钮
    UIButton *payButton = [[UIButton alloc] init];
    payButton.backgroundColor = PGCTintColor;
    payButton.layer.masksToBounds = true;
    payButton.layer.cornerRadius = 10.0;
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(respondsToPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    payButton.sd_layout
    .topSpaceToView(centerView, 35)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(60);
}


#pragma mark - Events

- (void)respondsToPayButton:(UIButton *)sender {
    PGCPayView *payView = [[PGCPayView alloc] init];
    payView.delegate = self;
    [payView showPayView];
}


#pragma mark - PGCPayViewDelegate

- (void)payView:(PGCPayView *)payView weChat:(UIButton *)weChat {    
    PGCPayView *succeedView = [[PGCPayView alloc] initWithSuccessPay];
    [succeedView showPayViewWithGCD];
}

- (void)payView:(PGCPayView *)payView alipay:(UIButton *)alipay {
    PGCPayView *succeedView = [[PGCPayView alloc] initWithSuccessPay];
    [succeedView showPayViewWithGCD];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = RGB(102, 102, 102);
    cell.textLabel.font = SetFont(15);
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

@end
