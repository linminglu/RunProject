//
//  PGCProjectContactScrollView.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectContactScrollView.h"
#import "PGCProjectDetailTagView.h"
#import "PGCProjectContactCell.h"
#import "PGCAlertView.h"
#import "PGCHintAlertView.h"
#import "PGCProjectAddContactController.h"
#import "PGCVIPServiceController.h"
#import "PGCMapTypeViewController.h"
#import "PGCProjectContact.h"
#import "PGCContact.h"

@interface PGCProjectContactScrollView () <UITableViewDataSource, UITableViewDelegate, PGCProjectContactCellDelegate, PGCAlertViewDelegate, PGCHintAlertViewDelegate>

@property (strong, nonatomic) UITableView *contactTableView;/** 联系人表格视图 */
@property (strong, nonatomic) UIButton *bottomBtn;/** 底部查看更多联系人视图 */

@property (strong, nonatomic) PGCProjectContact *projectContact;/** 项目联系人 */

- (void)initUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectContactScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    // 项目概况
    PGCProjectDetailTagView *contactView = [[PGCProjectDetailTagView alloc] initWithTitle:@"联系人及其联系方式"];
    [self.contentView addSubview:contactView];
    // 开始自动布局
    contactView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(40);
    
    // 联系人表格视图
    UITableView *contactTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contactTableView.showsVerticalScrollIndicator = false;
    contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contactTableView.dataSource = self;
    contactTableView.delegate = self;
    [contactTableView registerClass:[PGCProjectContactCell class] forCellReuseIdentifier:kProjectContactCell];
    [self.contentView addSubview:contactTableView];
    self.contactTableView = contactTableView;
    // 开始自动布局
    contactTableView.sd_layout
    .topSpaceToView(contactView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 50);
}

- (UIButton *)makeButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [button.titleLabel setFont:SetFont(14)];
    [button setTitle:@"查看更多联系人" forState:UIControlStateNormal];
    [button setTitleColor:PGCTintColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondsToCheckContact:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat imageInset = button.imageView.width;
    CGFloat titleInset = [button.titleLabel intrinsicContentSize].width / 2 - imageInset;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -titleInset);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -imageInset, 0, 0);
    
    return button;
}


#pragma mark - Events

- (void)respondsToCheckContact:(UIButton *)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectContactCell];
    cell.delegate = self;
    cell.projectContact = self.contactDataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectContact *projectContact = self.contactDataSource[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:projectContact keyPath:@"projectContact" cellClass:[PGCProjectContactCell class] contentViewWidth:SCREEN_WIDTH];
}


#pragma mark - PGCProjectContactCellDelegate

- (void)projectContactCell:(PGCProjectContactCell *)projectContactCell phone:(id)phone
{
    NSIndexPath *indexPath = [self.contactTableView indexPathForCell:projectContactCell];
    self.projectContact = self.contactDataSource[indexPath.row];
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        [MBProgressHUD showError:@"请先登录" toView:KeyWindow];
        return;
    }
    BOOL isRemind = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRemind"];
    
    PGCAlertView *alert = nil;
    
    if (user.is_vip == 1) {
        NSString *name = [NSString stringWithFormat:@"联系人：%@", self.projectContact.name];
        NSString *phone = [NSString stringWithFormat:@"呼叫%@", self.projectContact.phone];
        alert = [[PGCAlertView alloc] initWithModel:@{@"name":name, @"phone":phone}];
        
    } else {
        if (isRemind) {
            PGCVIPServiceController *vipVC = [[PGCVIPServiceController alloc] init];
            [[self getCurrentVC].navigationController pushViewController:vipVC animated:true];
        } else {
            alert = [[PGCAlertView alloc] initWithTitle:@"查看项目详情，需要您开通会员服务，如果您需要开通会员服务，请点击确定"];
        }
    }
    alert.delegate = self;    
    [alert showAlertView];
}

- (void)projectContactCell:(PGCProjectContactCell *)projectContactCell address:(id)address
{
    PGCMapTypeViewController *mapVC = [[PGCMapTypeViewController alloc] init];
    [[self getCurrentVC].navigationController pushViewController:mapVC animated:true];
}


#pragma mark - PGCAlertViewDelegate

- (void)alertView:(PGCAlertView *)alertView phone:(UIButton *)phone
{
    PGCHintAlertView *hintAlert = [[PGCHintAlertView alloc] initWithTitle:@"是否确定给联系人拨号？"];
    hintAlert.delegate = self;
    [hintAlert showHintAlertView];
}


- (void)alertView:(PGCAlertView *)alertView addContact:(UIButton *)addContact
{
    PGCProjectAddContactController *addContactVC = [[PGCProjectAddContactController alloc] init];
    addContactVC.projectCon = self.projectContact;
    [[self getCurrentVC].navigationController pushViewController:addContactVC animated:true];
}


- (void)alertView:(PGCAlertView *)alertView confirm:(UIButton *)confirm
{
    PGCVIPServiceController *vipVC = [[PGCVIPServiceController alloc] init];
    [[self getCurrentVC].navigationController pushViewController:vipVC animated:true];
}



#pragma mark - PGCHintAlertViewDelegate

- (void)hintAlertView:(PGCHintAlertView *)hintAlertView confirm:(UIButton *)confirm
{
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", self.projectContact.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}


- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        // UINavigationController *nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    } else {
        result = nextResponder;
    }
    return result;
}



#pragma mark - Setter

- (void)setContactDataSource:(NSArray *)contactDataSource
{
    _contactDataSource = contactDataSource;
    
    if (contactDataSource.count > 1) {
        [self bottomBtn];
    }
    [self.contactTableView reloadData];
}


#pragma mark - Getter

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [self makeButton];
        [self.contentView addSubview:_bottomBtn];
        _bottomBtn.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .heightIs(50);
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = RGB(230, 230, 250);
        [self.contentView addSubview:bottomLine];
        bottomLine.sd_layout
        .bottomSpaceToView(_bottomBtn, 0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1);
    }
    return _bottomBtn;
}

@end
