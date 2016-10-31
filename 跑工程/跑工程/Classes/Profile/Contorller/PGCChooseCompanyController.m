//
//  PGCChooseCompanyController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCChooseCompanyController.h"

@interface PGCChooseCompanyController ()


@end

@implementation PGCChooseCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveInfo)];
    
    self.navigationItem.rightBarButtonItem = right;
}

- (void) saveInfo
{
    self.block(self.companyTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

    




@end
