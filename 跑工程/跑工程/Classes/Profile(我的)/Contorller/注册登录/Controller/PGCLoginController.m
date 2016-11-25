//
//  PGCLoginController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCLoginController.h"
#import "PGCRegisterController.h"
#import "PGCResetPasswordController.h"
#import "PGCRegisterOrLoginAPIManager.h"
#import "PGCUserInfoController.h"

@interface PGCLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *userPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
    
}

- (void)initializeDataSource
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    self.userPhoneTF.text = user ? user.phone : @"";
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"登录";
    
    self.loginButton.layer.masksToBounds = true;
    self.loginButton.layer.cornerRadius = 10.0;
}

#pragma mark - Events
//登录按钮
- (IBAction)loginBtnClick:(UIButton *)sender
{    
    [self.view endEditing:true];
    
    if (![self.userPhoneTF.text isPhoneNumber]) {
        [PGCProgressHUD showMessage:@"请输入正确的手机号" toView:self.view];
        return;
    }
    if (self.userPasswordTF.text.length < 6) {
        [PGCProgressHUD showMessage:@"请输入6位数以上的密码" toView:self.view];
        return;
    }    
    NSDictionary *params = @{@"phone":self.userPhoneTF.text,
                             @"password":self.userPasswordTF.text};
    
    MBProgressHUD *hud = [PGCProgressHUD showProgress:@"登录中..." toView:self.view];
    
    [PGCRegisterOrLoginAPIManager loginRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [hud hideAnimated:true];
        if (status == RespondsStatusSuccess) {
            // 发送登录成功的通知给 我的 控制器
            [PGCNotificationCenter postNotificationName:kReloadProfileInfo object:nil userInfo:@{@"Login":@"登录成功"}];
            // 控制器的跳转
            if ([self.vc isKindOfClass:[PGCUserInfoController class]]) {
                // 跳到 个人中心 控制器
                [self.navigationController pushViewController:self.vc animated:true];
                [self.navigationController popToRootViewControllerAnimated:false];
                [PGCNotificationCenter postNotificationName:kProfileNotification object:self.vc userInfo:nil];
            } else {
                // 跳到 我的 控制器
                [self.navigationController popViewControllerAnimated:true];
            }
        } else {
            [PGCProgressHUD showAlertWithTarget:self title:@"登录失败：" message:message actionWithTitle:@"我知道了" handler:nil];
        }
    }];
}

//注册按钮
- (IBAction)registerNowBtnClick:(UIButton *)sender
{
    PGCRegisterController *registerVC = [[PGCRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:true];
}

//找回密码
- (IBAction)resetPasswordBtnClick:(UIButton *)sender
{
    PGCResetPasswordController *resetPassVC = [[PGCResetPasswordController alloc] init];
    resetPassVC.navigationItem.title = @"忘记密码";
    [self.navigationController pushViewController:resetPassVC animated:true];
}


@end
