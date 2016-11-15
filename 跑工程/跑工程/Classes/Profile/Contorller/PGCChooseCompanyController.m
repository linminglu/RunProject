//
//  PGCChooseCompanyController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCChooseCompanyController.h"

@interface PGCChooseCompanyController ()

@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

@end

@implementation PGCChooseCompanyController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.companyTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveInfo:)];
}


#pragma mark - Event

- (void)saveInfo:(UIBarButtonItem *)sedner {
    self.block(self.companyTextField.text);
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}



@end
