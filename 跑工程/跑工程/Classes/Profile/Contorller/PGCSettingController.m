//
//  PGCSettingController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSettingController.h"
#import "PGCRegisterOrLoginAPIManager.h"
#import "JCAlertView.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

@interface PGCSettingController ()

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;/** 退出账号按钮 */

@end

@implementation PGCSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutBtn.layer.masksToBounds = true;
    self.logoutBtn.layer.cornerRadius = 10.0;
}


#pragma mark - Events
// 退出登录
- (IBAction)logoutEvent:(UIButton *)sender
{
    PGCTokenManager *manager = [PGCTokenManager tokenManager];
    [manager readAuthorizeData];
    PGCUserInfo *user = manager.token.user;
    
    if (!user) {
        [PGCProgressHUD showProgressHUDWithTitle:@"请先登录"];
        return;
    }
    
    NSDictionary *params = @{@"user_id":@(user.id),
                             @"client_type":@"iphone",
                             @"token":manager.token.token};
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示:" Message:@"是否确定注销登录?" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"注销" Click:^{
        MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:@"注销中..."];
        
        [PGCRegisterOrLoginAPIManager logoutRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                [PGCProgressHUD showProgressHUDWithTitle:@"成功退出登录!"];
                // 发送退出登录的通知给 我的 控制器
                [PGCNotificationCenter postNotificationName:kReloadProfileInfo object:nil userInfo:@{@"Logout":@"退出登录"}];
                
                [[PGCTokenManager tokenManager] logout];
                
            } else {
                [PGCProgressHUD showAlertWithTarget:self title:@"退出登录失败：" message:message actionWithTitle:@"确定" handler:nil];
            }
        }];

    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"取消" Click:^{
        
    }];
}

@end
