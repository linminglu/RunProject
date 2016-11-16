//
//  PGCResetPasswordController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCResetPasswordController.h"
#import "MZTimerLabel.h"
#import "PGCRegisterOrLoginAPIManager.h"
#import "PGCRegistInfo.h"
#import "PGCLoginController.h"

@interface PGCResetPasswordController () <MZTimerLabelDelegate>
{
    UILabel *_timerShow;/** 倒计时label */
    UIColor *_recevieIDBtnColor;/** 获取验证码初始背景颜色 */
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *recevieIDBtn;/** 获取验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;/** 确认按钮 */

@property (strong, nonatomic) PGCRegistInfo *registerInfo;/** 注册的模型 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCResetPasswordController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.phoneTF becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    //记录获取验证码最初的背景颜色
    _recevieIDBtnColor = self.recevieIDBtn.backgroundColor;
    
    self.confirmBtn.layer.masksToBounds = true;
    self.confirmBtn.layer.cornerRadius = 10.0;
}

#pragma mark - Events

/**
 确认修改
 */
- (IBAction)confirmBtnClick:(UIButton *)sender {
    
    [self.view endEditing:true];

    if (![self.phoneTF.text isPhoneNumber]) {
        [PGCProgressHUD showMessage:@"请输入正确的手机号" inView:self.view];
        return;
    }
    // 判断是否输入验证码
    if (!(self.verifyCodeTF.text.length > 0)) {
        [PGCProgressHUD showMessage:@"请输入验证码" inView:self.view];
        return;
    }
    // 判断是否输入密码
    if (self.passwordTF.text.length < 6) {
        [PGCProgressHUD showMessage:@"请输入6位数以上的密码" inView:self.view];
        return;
    }
    // 判断密码验证是否正确
    if (![self.checkPasswordTF.text isEqualToString:self.passwordTF.text]) {
        [PGCProgressHUD showMessage:@"密码验证失败" inView:self.view];
        self.checkPasswordTF.text = @"";
        return;
    }
    
    self.registerInfo.phone = self.phoneTF.text;
    self.registerInfo.verify_code = self.verifyCodeTF.text;
    self.registerInfo.password = self.passwordTF.text;
    self.registerInfo.password2 = self.checkPasswordTF.text;
    
    NSDictionary *params = self.registerInfo.mj_keyValues;
    
    MBProgressHUD *hud;
    
    if ([self.navigationItem.title isEqualToString:@"忘记密码"]) {
        
        hud = [PGCProgressHUD showProgressHUD:self.view label:@"重置密码中..."];
        
        [PGCRegisterOrLoginAPIManager forgetPasswordRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"密码重置成功，请重新登录！" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:true];
                }];
            }
            else {
                [PGCProgressHUD showAlertWithTarget:self title:@"密码重置失败：" message:message actionWithTitle:@"确定" handler:nil];
            }
        }];
        
    } else {
        
        hud = [PGCProgressHUD showProgressHUD:self.view label:@"修改密码中..."];
        
        [PGCRegisterOrLoginAPIManager forgetPasswordRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            
            [hud hideAnimated:true];
            
            if (status == RespondsStatusSuccess) {
                
                [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"密码修改成功，请重新登录！" actionWithTitle:@"确定" handler:^(UIAlertAction *action) {
                    
                    PGCLoginController *loginVC = [[PGCLoginController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:true];
                    [self.navigationController popToRootViewControllerAnimated:false];
                    [PGCNotificationCenter postNotificationName:kProfileNotification object:loginVC userInfo:nil];
                }];
            }
            else {
                [PGCProgressHUD showAlertWithTarget:self title:@"密码修改失败：" message:message actionWithTitle:@"确定" handler:nil];
            }
        }];
    }
}

/**
 获取验证
 */
- (IBAction)recevieIDBtnClick:(UIButton *)sender {
    
    [self.view endEditing:true];
    
    if ([self.phoneTF.text isPhoneNumber]) {
        //倒计时
        [self timeCount];
        
        NSDictionary *params = @{@"phone":self.phoneTF.text, @"type":@0};
        [PGCRegisterOrLoginAPIManager sendVerifyCodeURLRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                [PGCProgressHUD showMessage:@"验证码发送成功，请查看您的手机短信！" inView:self.view];
            }
        }];
    } else {
        [PGCProgressHUD showMessage:@"请输入正确的手机号" inView:self.view];
        return;
    }
}

/**
 倒计时
 */
- (void)timeCount
{
    [self.recevieIDBtn setTitle:nil forState:UIControlStateNormal];
    _timerShow = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 20)];
    [self.recevieIDBtn addSubview:_timerShow];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:_timerShow andTimerType:MZTimerLabelTypeTimer];
    [timer_cutDown setCountDownTime:60];
    timer_cutDown.timeFormat = @"倒计时 (ss)";
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:14.0];
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;
    timer_cutDown.delegate = self;
    self.recevieIDBtn.userInteractionEnabled = false;
    [timer_cutDown start];
    self.recevieIDBtn.backgroundColor = [UIColor grayColor];
}



#pragma mark - MZTimerLabelDelegate

/**
 倒计时结束后的代理方法

 @param timerLabel
 @param countTime
 */
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [self.recevieIDBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_timerShow removeFromSuperview];
    
    self.recevieIDBtn.userInteractionEnabled = true;
    self.recevieIDBtn.backgroundColor = _recevieIDBtnColor;
}


#pragma mark - Getter

- (PGCRegistInfo *)registerInfo {
    if (!_registerInfo) {
        _registerInfo = [[PGCRegistInfo alloc] init];
    }
    return _registerInfo;
}

@end
