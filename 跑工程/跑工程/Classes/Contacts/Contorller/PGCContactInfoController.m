//
//  PGCContactInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactInfoController.h"
#import "PGCContactInfoCell.h"
#import "PGCProjectCell.h"
#import "PGCContacInfoHeaderView.h"
#import "PGCContactAPIManager.h"
#import "PGCContact.h"
#import "JCAlertView.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

@interface PGCContactInfoController () <UITableViewDataSource, UITableViewDelegate, PGCContacInfoHeaderViewDelegate>
{
    BOOL _isLeft;
}
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end


@implementation PGCContactInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}


- (void)initializeUserInterface
{
    self.navigationItem.title = @"个人资料";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除联系人" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToDeleteContact:)];
    
    _isLeft = true;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - Evetns

- (void)respondsToDeleteContact:(UIBarButtonItem *)sender
{
    PGCTokenManager *manager = [PGCTokenManager tokenManager];
    [manager readAuthorizeData];
    PGCUserInfo *user = manager.token.user;
    NSDictionary *params = @{@"user_id":@(user.id),
                             @"client_type":@"iphone",
                             @"token":manager.token.token,
                             @"ids_json":@"[]"};
    
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示:" Message:@"是否删除该联系人？" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"是" Click:^{
        MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:@"删除中..."];
        
        [PGCContactAPIManager deleteContactRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                
                
            }
        }];
    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"否" Click:^{
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isLeft ? 1 : 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isLeft) {
        PGCContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCContactInfoCell];
        
        return cell;
        
    } else {
        PGCProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCProjectCell];
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PGCContacInfoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kContacInfoHeaderView];
    headerView.delegate = self;
    headerView.contactHeader = self.contactInfo;
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _isLeft ? 450 : 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 172;
}


#pragma mark - PGCContacInfoHeaderViewDelegate

- (void)contactInfoHeaderView:(PGCContacInfoHeaderView *)headerView contactInfoBtn:(UIButton *)contactInfoBtn
{
    _isLeft = true;
    [self.tableView reloadData];
}

- (void)contactInfoHeaderView:(PGCContacInfoHeaderView *)headerView projectsBtn:(UIButton *)projectsBtn
{
    _isLeft = false;    
    [self.tableView reloadData];
}


#pragma mark - Setter

- (void)setContactInfo:(PGCContact *)contactInfo
{
    _contactInfo = contactInfo;
    
    if (!contactInfo) {
        return;
    }
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = false;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCContacInfoHeaderView class] forHeaderFooterViewReuseIdentifier:kContacInfoHeaderView];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PGCContactInfoCell class]) bundle:nil] forCellReuseIdentifier:kPGCContactInfoCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PGCProjectCell class]) bundle:nil] forCellReuseIdentifier:kPGCProjectCell];
    }
    return _tableView;
}

@end
