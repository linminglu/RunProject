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

@interface PGCLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@end

@implementation PGCLoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
//    显示导航条
    [self.navigationController.navigationBar setHidden:NO];
    
//    设置登录按钮的圆角效果
    self.LoginButton.layer.cornerRadius = 10;
    
}

//注册按钮
- (IBAction)registerNowBtnClick:(id)sender {
    
    PGCRegisterController *registerVC = [[PGCRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
//找回密码
- (IBAction)resetPasswordBtnClick:(id)sender {
    PGCResetPasswordController *resetPassVC = [[PGCResetPasswordController alloc] init];
    resetPassVC.title = @"忘记密码";
    [self.navigationController pushViewController:resetPassVC animated:YES];
}

@end
