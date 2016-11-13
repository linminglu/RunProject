//
//  PGCChooseJobController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCChooseJobController.h"
#import "PGCProfileAPIManager.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

@interface PGCChooseJobController ()

@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (strong, nonatomic) UIBarButtonItem *saveItem;/** 保存按钮 */
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 上传参数 */

@end

@implementation PGCChooseJobController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.jobTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveInfo:)];

    self.navigationItem.rightBarButtonItem = self.saveItem;
    
    PGCTokenManager *manager = [PGCTokenManager tokenManager];
    [manager readAuthorizeData];
    PGCUserInfo *user = manager.token.user;
    
    self.jobTextField.text = user.post;
    
    RAC(self.saveItem, enabled) = [RACSignal combineLatest:@[[self.jobTextField rac_textSignal]] reduce:^id(NSString *text) {
        return @(text.length > 0 && ![text isEqualToString:user.post]);
    }];
}


#pragma mark - Events

- (void)saveInfo:(UIBarButtonItem *)sender {
    
    [self.view endEditing:true];
    
    [self.parameters setObject:self.jobTextField.text forKey:@"post"];
    
    MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:@"保存中..."];
    [PGCProfileAPIManager completeInfoRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        [hud hideAnimated:true];
        
        if (status == RespondsStatusSuccess) {
            
            self.block(self.jobTextField.text);
            
            [self.navigationController popViewControllerAnimated:true];
            
        } else {
            [PGCProgressHUD showAlertWithTarget:self title:@"保存失败：" message:message actionWithTitle:@"确定" handler:nil];
        }
    }];
}


#pragma mark - Getter

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setObject:@"iphone" forKey:@"client_type"];
        [_parameters setObject:[PGCTokenManager tokenManager].token.token forKey:@"token"];
        [_parameters setObject:@([PGCTokenManager tokenManager].token.user.id) forKey:@"user_id"];
    }
    return _parameters;
}



#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}


@end
