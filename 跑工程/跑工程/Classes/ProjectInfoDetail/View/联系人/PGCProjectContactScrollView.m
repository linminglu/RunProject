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
#import "PGCProjectInfo.h"
#import "PGCProjectContact.h"

@interface PGCProjectContactScrollView () <UITableViewDataSource, UITableViewDelegate, PGCProjectContactCellDelegate, PGCAlertViewDelegate, PGCHintAlertViewDelegate>
{
    BOOL _isVIP;/** 判断是否是会员 */
}

@property (strong, nonatomic) UITableView *contactTableView;/** 联系人表格视图 */
@property (strong, nonatomic) UIButton *bottomBtn;/** 底部查看更多联系人视图 */

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

- (void)initUserInterface {
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

- (UIButton *)makeButton {
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

- (void)respondsToCheckContact:(UIButton *)sender {
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
    BOOL isRemind = [[PGCUserDefault valueForKey:@"isRemind"] boolValue];
    
    PGCAlertView *alert = nil;
    
    if (!_isVIP) {
        alert = [[PGCAlertView alloc] initWithModel:@{@"name":@"联系人：夏先生", @"phone":@"呼叫188883359584"}];
        
    } else {
        if (isRemind) {
            [[self getCurrentVC].navigationController pushViewController:[PGCVIPServiceController new] animated:true];
        } else {
            alert = [[PGCAlertView alloc] initWithTitle:@"查看项目详情，需要您开通会员服务，如果您需要开通会员服务，请点击确定"];
        }
    }
    alert.delegate = self;
    
    [alert showAlertView];
}

- (void)projectContactCell:(PGCProjectContactCell *)projectContactCell address:(id)address
{    
    [[self getCurrentVC].navigationController pushViewController:[PGCMapTypeViewController new] animated:true];
}


#pragma mark - PGCAlertViewDelegate

- (void)alertView:(PGCAlertView *)alertView phone:(UIButton *)phone
{
    PGCHintAlertView *hintAlert = [[PGCHintAlertView alloc] initWithTitle:@"是否确定给联系人拨号"];
    hintAlert.delegate = self;
    [hintAlert showHintAlertView];
}


- (void)alertView:(PGCAlertView *)alertView addContact:(UIButton *)addContact
{
    [[self getCurrentVC].navigationController pushViewController:[PGCProjectAddContactController new] animated:true];
}


- (void)alertView:(PGCAlertView *)alertView confirm:(UIButton *)confirm
{
    [[self getCurrentVC].navigationController pushViewController:[PGCVIPServiceController new] animated:true];
}



#pragma mark - PGCHintAlertViewDelegate

- (void)hintAlertView:(PGCHintAlertView *)hintAlertView confirm:(UIButton *)confirm {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8008808888"]];
}


- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        // UINavigationController *nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
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
