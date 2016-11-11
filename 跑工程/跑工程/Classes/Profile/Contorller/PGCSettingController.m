//
//  PGCSettingController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSettingController.h"
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
- (IBAction)logoutEvent:(UIButton *)sender {
    
}

@end
