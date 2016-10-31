//
//  PGCSettingController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSettingController.h"

@interface PGCSettingController ()
//退出账号按钮
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation PGCSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
//  设置退出按钮圆角效果
    self.logoutBtn.layer.cornerRadius = 10;
}



@end
