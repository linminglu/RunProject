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


@interface PGCUserInfoController ()<UIActionSheetDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;
//性别
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
//职位
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
//公司
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;


//选择性别选择框
@property (nonatomic,strong) UIActionSheet *actionSheet;

@end

@implementation PGCUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self.navigationController.navigationBar setHidden:NO];
    
    // 设置头像圆角效果和边框
    self.icon.layer.cornerRadius = 20;
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.borderWidth = 1;
    
    // 创建弹出视图
    [self creatPopView];
    
}

//选择性别
- (IBAction)sexBtnClick:(id)sender {
    [self.view addSubview:_actionSheet];
    [_actionSheet showFromRect:CGRectMake(0, 0, 50, 50) inView:self.view animated:YES];

}

//选择职位
- (IBAction)jobBtnClick:(id)sender {
    __weak PGCUserInfoController *weakSelf = self;
    PGCChooseJobController *jobVC = [[PGCChooseJobController alloc] init];
    jobVC.block = ^(NSString *job) {
        weakSelf.jobLabel.text = job;
    };
    [self.navigationController pushViewController:jobVC animated:YES];
}

////选择公司
//- (IBAction)chooseCompanyBtnClick:(id)sender {
//    
//    if ([self.companyLabel.text isEqualToString:@"未填写"]) {
//        __weak PGCUserInfoController *weakSelf = self;
//        PGCChooseCompanyController *companyVC = [[PGCChooseCompanyController alloc] init];
//        
//        companyVC.block = ^(NSString *job) {
//            weakSelf.companyLabel.text = job;
//        };
//        [self.navigationController pushViewController:companyVC animated:YES];
//    }
//}

//创建弹出视图
- (void) creatPopView {
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男", nil];
    [_actionSheet addButtonWithTitle:@"女"];
    [_actionSheet addButtonWithTitle:@"取消"];
    _actionSheet.cancelButtonIndex = _actionSheet.numberOfButtons -1;
}

#pragma mark -------- actionSheet代理方法

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.sexLabel.text = @"男";
            break;
        case 1:
            self.sexLabel.text = @"女";
            break;
        default:
            break;
    }
}



@end
