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
#import "PGCToken.h"

@interface PGCProfileController ()

@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;


- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

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
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    NSString *tokenPath = [PGCCachesPath stringByAppendingPathComponent:@"TokenInfo.plist"];
    
    PGCToken *token = [NSKeyedUnarchiver unarchiveObjectWithFile:tokenPath];
    
    if (token) {
        [PGCToken token].isLogin = true;
    } else {
        [PGCToken token].isLogin = false;
    }
}

- (void)initializeUserInterface {
    
    self.headImageBtn.layer.masksToBounds = true;
    self.headImageBtn.layer.cornerRadius = 65 / 2;
    
    
}

#pragma mark - Event

/**
 头像, 未登录前不能点击

 @param sender
 */
- (IBAction)iconButtonClick:(UIButton *)sender {
    NSLog(@"haha");
}

/**
 登录/注册 block回调登录信息

 @param sender
 */
- (IBAction)iconLabelButtonClick:(UIButton *)sender {
    PGCLoginController *loginVC = [[PGCLoginController alloc] init];
    [self.navigationController pushViewController:loginVC animated:true];
}

/**
 个人中心

 @param sender
 */
- (IBAction)userInfoButtonClick:(UIButton *)sender {
    PGCUserInfoController *userInfoVC = [[PGCUserInfoController alloc] init];
    [self.navigationController pushViewController:userInfoVC animated:true];
}

/**
 设置

 @param sender
 */
- (IBAction)settingButtonClick:(UIButton *)sender {
    PGCSettingController *settingVC = [[PGCSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:true];
}

/**
 推荐给好友

 @param send
 */
- (IBAction)commendToFriendButtonClick:(UIButton *)sender {
    PGCShareToFriendController *shareVC = [[PGCShareToFriendController alloc] init];
    [self.navigationController pushViewController:shareVC animated:true];
}

/**
 修改密码按钮

 @param sender
 */
- (IBAction)updataPassWordButtonClick:(UIButton *)sender {
    PGCResetPasswordController *resetPassVC = [[PGCResetPasswordController alloc] init];
    resetPassVC.navigationItem.title = @"修改密码";
    [self.navigationController pushViewController:resetPassVC animated:true];
}

/**
 会员中心

 @param sender
 */
- (IBAction)VIPInfoButtonClick:(UIButton *)sender {
    [PGCProgressHUD showMsgWithoutView:@"VIP用户"];
}


@end
