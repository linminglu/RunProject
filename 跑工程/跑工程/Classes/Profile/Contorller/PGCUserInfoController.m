//
//  PGCUserInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCUserInfoController.h"
#import "PGCChooseJobController.h"
#import "PGCChooseCompanyController.h"


@interface PGCUserInfoController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;/** 头像 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;/** 性别 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;/** 手机 */
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;/** 职位 */
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;/** 公司 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"个人资料";
    
    self.icon.layer.masksToBounds = true;
    self.icon.layer.cornerRadius = 20.0;
    self.icon.layer.borderWidth = 1.0;
}

#pragma mark - Events
// 选择性别
- (IBAction)sexBtnClick:(UIButton *)sender {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLabel.text = @"男";
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLabel.text = @"女";
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertView animated:true completion:nil];
}

//选择职位
- (IBAction)jobBtnClick:(UIButton *)sender {
    __weak PGCUserInfoController *weakSelf = self;
    PGCChooseJobController *jobVC = [[PGCChooseJobController alloc] init];
    jobVC.block = ^(NSString *job) {
        weakSelf.jobLabel.text = job;
    };
    [self.navigationController pushViewController:jobVC animated:true];
}

/***
//选择公司
- (IBAction)chooseCompanyBtnClick:(id)sender {
    
    if ([self.companyLabel.text isEqualToString:@"未填写"]) {
        __weak PGCUserInfoController *weakSelf = self;
        PGCChooseCompanyController *companyVC = [[PGCChooseCompanyController alloc] init];
        
        companyVC.block = ^(NSString *job) {
            weakSelf.companyLabel.text = job;
        };
        [self.navigationController pushViewController:companyVC animated:YES];
    }
}
***/


@end
