//
//  PGCRegisterController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCRegisterController.h"
#import "MZTimerLabel.h"
#import "PGCRegistInfo.h"
#import "PGCRegisterOrLoginAPIManager.h"

@interface PGCRegisterController () <MZTimerLabelDelegate>
{
    UILabel *_timerShow;/** 倒计时label */
    UIColor *_recevieIDBtnColor;/** 获取验证码初始背景颜色 */
}

@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTF;

@property (weak, nonatomic) IBOutlet UIButton *recevieIDBtn;/** 获取验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;/** 注册按钮 */

@property (strong, nonatomic) PGCRegistInfo *registerInfo;/** 注册的模型 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.title = @"注册";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = PGCBackColor;
    
    // 记录获取验证码最初的背景颜色
    _recevieIDBtnColor = self.recevieIDBtn.backgroundColor;
    
    self.registerButton.layer.masksToBounds = true;
    self.registerButton.layer.cornerRadius = 10.0;
}

#pragma mark - Events
/**
 注册

 @param sender 
 */
- (IBAction)registerBtnClick:(UIButton *)sender {
    
    [self.view endEditing:true];
    
    // 判断是否输入公司名
    if (!(self.companyTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入公司名称或个人名称" toView:self.view];
        return;
    }
    // 判断是否输入姓名
    if (!(self.nameTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入姓名" toView:self.view];
        return;
    }
    // 判断是否输入手机号
    if (![self.phoneTF.text isPhoneNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        return;
    }
    // 判断是否输入验证码
    if (!(self.verifyCodeTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    // 判断是否输入密码
    if (self.passwordTF.text.length < 6) {
        [MBProgressHUD showError:@"请输入6位数以上的密码" toView:self.view];
        return;
    }
    // 判断密码验证是否正确
    if (![self.checkPasswordTF.text isEqualToString:self.passwordTF.text]) {
        [MBProgressHUD showError:@"密码验证失败" toView:self.view];
        self.checkPasswordTF.text = @"";
        return;
    }
    
    self.registerInfo.company = self.companyTF.text;
    self.registerInfo.name = self.nameTF.text;
    self.registerInfo.phone = self.phoneTF.text;
    self.registerInfo.verify_code = self.verifyCodeTF.text;
    self.registerInfo.password = self.passwordTF.text;
    self.registerInfo.password2 = self.checkPasswordTF.text;
    
    NSDictionary *parameters = self.registerInfo.mj_keyValues;
    
    MBProgressHUD *hud = [PGCProgressHUD showProgress:@"注册中..." toView:self.view];
    
    [PGCRegisterOrLoginAPIManager registerRequestWithParameters:parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        [hud hideAnimated:true];
        
        if (status == RespondsStatusSuccess) {            
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"注册成功，请返回登录！" actionWithTitle:@"确定" handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:true];
            }];
        } else {
            [PGCProgressHUD showAlertWithTarget:self title:@"注册失败：" message:message actionWithTitle:@"我知道了" handler:nil];
        }
    }];
}


#pragma mark - Event
/**
 获取验证码

 @param sender
 */
- (IBAction)recevieIDBtnClick:(UIButton *)sender
{    
    [self.view endEditing:true];
    
    if ([self.phoneTF.text isPhoneNumber]) {
        NSDictionary *params = @{@"phone":self.phoneTF.text, @"type":@0};
        MBProgressHUD *hud = [PGCProgressHUD showProgress:nil toView:self.view];
        [PGCRegisterOrLoginAPIManager sendVerifyCodeURLRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            if (status == RespondsStatusSuccess) {
                //倒计时
                [self timeCount];
                [PGCProgressHUD showMessage:@"验证码发送成功，请查看您的手机短信！" toView:self.view afterDelayTime:2.0];
            }
        }];
    } else {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
    }
}

/**
 倒计时
 */
- (void)timeCount {
    //把按钮原先的名字消掉
    [self.recevieIDBtn setTitle:nil forState:UIControlStateNormal];
    
    //UILabel设置成和UIButton一样的尺寸和位置
    _timerShow = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 20)];
    
    //把timer_show添加到_dynamicCode_btn按钮上
    [self.recevieIDBtn addSubview:_timerShow];
    
    //创建MZTimerLabel类的对象timer_cutDown
    MZTimerLabel *timerCutDown = [[MZTimerLabel alloc] initWithLabel:_timerShow andTimerType:MZTimerLabelTypeTimer];
    //倒计时时间60s
    [timerCutDown setCountDownTime:60];
    //倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timerCutDown.timeFormat = @"倒计时 (ss)";
    timerCutDown.timeLabel.textColor = [UIColor whiteColor];
    timerCutDown.timeLabel.font = [UIFont systemFontOfSize:14.0];
    timerCutDown.timeLabel.textAlignment = NSTextAlignmentCenter;
    timerCutDown.delegate = self;
    self.recevieIDBtn.userInteractionEnabled = false;
    //开始计时
    [timerCutDown start];
    self.recevieIDBtn.backgroundColor = [UIColor grayColor];
}

#pragma mark - MZTimerLabelDelegate
/**
 倒计时结束后的代理方法

 @param timerLabel
 @param countTime
 */
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    //倒计时结束后按钮名称改为"获取验证码"
    [self.recevieIDBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    //移除倒计时模块
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
