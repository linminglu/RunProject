//
//  PGCProfileController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProfileController.h"

#import "PGCRegisterController.h"
#import "PGCLoginController.h"
#import "PGCResetPasswordController.h"

#import "PGCSettingController.h"
#import "PGCUserInfoController.h"
#import "PGCShareToFriendController.h"

@interface PGCProfileController ()
//顶部橙色界面
@property (weak, nonatomic) IBOutlet UIView *headView;
//头像的X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconX;
//登录/注册按钮的X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLebelX;
//头像上按钮的X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconButtonX;
//头像按钮点击事件
- (IBAction)iconButtonClick:(id)sender;
//登录/注册按钮点击事件
- (IBAction)iconLabelButtonClick:(id)sender;

//个人中心按钮点击事件
- (IBAction)userInfoButtonClick:(id)sender;

//设置按钮点击事件
- (IBAction)settingButtonClick:(id)sender;

//推荐给好友按钮点击事件
- (IBAction)commendToFriendButtonClick:(id)sender;

//修改密码按钮点击事件
- (IBAction)updataPassWordButtonClick:(id)sender;

//会员中心点击事件
- (IBAction)VIPInfoButtonClick:(id)sender;


@end

@implementation PGCProfileController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置头像的X
    self.iconX.constant = (SCREEN_WIDTH - 65) / 2;
    // 设置头像上的按钮的X
    self.iconButtonX.constant = (SCREEN_WIDTH - 80) / 2;
    
    // 设置登录/注册按钮的X
    self.iconLebelX.constant = self.iconX.constant;
}


// 未登录前不能点击
- (IBAction)iconButtonClick:(id)sender {
    NSLog(@"haha");
}

// block回调登录信息
- (IBAction)iconLabelButtonClick:(id)sender {
    PGCLoginController *loginVC = [[PGCLoginController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)userInfoButtonClick:(id)sender {
    PGCUserInfoController *userInfoVC = [[PGCUserInfoController alloc] init];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (IBAction)settingButtonClick:(id)sender {
    PGCSettingController *settingVC = [[PGCSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction)commendToFriendButtonClick:(id)sender {
    PGCShareToFriendController *shareVC = [[PGCShareToFriendController alloc] init];
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (IBAction)updataPassWordButtonClick:(id)sender {
    PGCResetPasswordController *resetPassVC = [[PGCResetPasswordController alloc] init];
    resetPassVC.title = @"修改密码";
    [self.navigationController pushViewController:resetPassVC animated:YES];
}


- (IBAction)VIPInfoButtonClick:(id)sender {
    NSLog(@"VIP中心");
}


@end
