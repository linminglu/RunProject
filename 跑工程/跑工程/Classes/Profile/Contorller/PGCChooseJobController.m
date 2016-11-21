//
//  PGCChooseJobController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCChooseJobController.h"
#import "PGCProfileAPIManager.h"

@interface PGCChooseJobController ()

@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 上传参数 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCChooseJobController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.jobTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}


- (void)initializeUserInterface
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveInfo:)];
    
    self.navigationItem.rightBarButtonItem = saveItem;
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    self.jobTextField.text = user.post;
    
    RAC(saveItem, enabled) = [RACSignal combineLatest:@[[self.jobTextField rac_textSignal]] reduce:^id(NSString *text) {
        return @(text.length > 0 && ![text isEqualToString:user.post]);
    }];
}

#pragma mark - Events

- (void)saveInfo:(UIBarButtonItem *)sender
{
    [self.view endEditing:true];
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    [self.parameters setObject:@"iphone" forKey:@"client_type"];
    [self.parameters setObject:manager.token.token forKey:@"token"];
    [self.parameters setObject:@(user.user_id) forKey:@"user_id"];
    [self.parameters setObject:self.jobTextField.text forKey:@"post"];
    
    MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:nil];
    
    [PGCProfileAPIManager completeInfoRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        [hud hideAnimated:true];
        
        if (status == RespondsStatusSuccess) {
            self.block(self.jobTextField.text);
            [self.navigationController popViewControllerAnimated:true];            
        } else {
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                
            }];
        }
    }];
}


#pragma mark - Getter

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}


@end
