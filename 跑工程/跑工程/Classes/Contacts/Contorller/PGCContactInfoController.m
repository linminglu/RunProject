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

@interface PGCContactInfoController () <UITableViewDataSource, UITableViewDelegate, PGCContacInfoHeaderViewDelegate, PGCContactInfoCellDelegate>
{
    BOOL _isLeft;
}

@property (strong, nonatomic) PGCContacInfoHeaderView *headerView;/** 上半部视图 */
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
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
}


#pragma mark - Evetns

- (void)respondsToDeleteContact:(UIBarButtonItem *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    NSMutableArray *array = [NSMutableArray array];
    for (PGCContact *contact in @[self.contactInfo]) {
        [array addObject:@(contact.id)];
    }
    NSString *ids_json = [PGCBaseAPIManager jsonToString:array];
    NSDictionary *params = @{@"user_id":@(user.user_id),
                             @"client_type":@"iphone",
                             @"token":manager.token.token,
                             @"ids_json":ids_json};
    
    [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"是否删除该联系人？" actionTitle:@"确定" otherActionTitle:@"取消" handler:^(UIAlertAction *action) {
        MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:@"删除中..."];
        
        [PGCContactAPIManager deleteContactRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                [PGCNotificationCenter postNotificationName:kContactReloadData object:nil userInfo:@{@"DeleteContact":@"删除联系人"}];
                [self.navigationController popViewControllerAnimated:true];
            } else {
                [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                    
                }];
            }
        }];
    } otherHandler:^(UIAlertAction *action) {
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isLeft ? 1 : 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isLeft) {
        PGCContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCContactInfoCell];
        cell.contactLeft = self.contactInfo;
        cell.delegate = self;
        return cell;
        
    } else {
        PGCProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCProjectCell];
        cell.contactRight = self.contactInfo;
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _isLeft ? 420 : 44;
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



#pragma mark - PGCContactInfoCellDelegate

- (void)contactInfoCell:(PGCContactInfoCell *)contactInfoCell textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(self.view.centerX_sd, self.view.centerY_sd - 100);
    }];
}

- (void)contactInfoCell:(PGCContactInfoCell *)contactInfoCell textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(self.view.centerX_sd, SCREEN_HEIGHT / 2);
    }];
}


#pragma mark - Getter

- (PGCContacInfoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PGCContacInfoHeaderView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, 172)];
        _headerView.delegate = self;
        _headerView.contactHeader = self.contactInfo;
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom_sd, self.view.width_sd, self.view.height_sd - self.headerView.bottom_sd) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.showsHorizontalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PGCContactInfoCell class]) bundle:nil] forCellReuseIdentifier:kPGCContactInfoCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PGCProjectCell class]) bundle:nil] forCellReuseIdentifier:kPGCProjectCell];
    }
    return _tableView;
}

@end
