//
//  PGCResetPasswordController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCResetPasswordController.h"
#import "MZTimerLabel.h"

@interface PGCResetPasswordController () <MZTimerLabelDelegate>
{
    UILabel *_timerShow;/** 倒计时label */
    UIColor *_recevieIDBtnColor;/** 获取验证码初始背景颜色 */
}

@property (weak, nonatomic) IBOutlet UIButton *recevieIDBtn;/** 获取验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;/** 确认按钮 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"注册";
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
    
    [PGCProgressHUD showMsgWithoutView:@"修改密码"];
}

/**
 获取验证
 */
- (IBAction)recevieIDBtnClick:(UIButton *)sender {
    //倒计时
    [self timeCount];
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


@end
