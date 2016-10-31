//
//  PGCRegisterController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCRegisterController.h"
#import "MZTimerLabel.h"

@interface PGCRegisterController ()<MZTimerLabelDelegate>
//注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
//倒计时label
@property (nonatomic,strong) UILabel *timer_show;
//获取验证码初始背景颜色
@property (nonatomic,strong) UIColor *recevieIDBtnColor;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *recevieIDBtn;



@end

@implementation PGCRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.registerButton.layer.cornerRadius = 10;
//    记录获取验证码最初的背景颜色
    self.recevieIDBtnColor = self.recevieIDBtn.backgroundColor;
}
//获取验证码
- (IBAction)recevieIDBtnClick:(id)sender {
    //    倒计时
    [self timeCount];
}

//倒计时
- (void)timeCount{//倒计时函数
    [self.recevieIDBtn setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    _timer_show = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 80, 20)];//UILabel设置成和UIButton一样的尺寸和位置
    [self.recevieIDBtn addSubview:_timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:_timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"倒计时 (ss)";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:14.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    self.recevieIDBtn.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
    self.recevieIDBtn.backgroundColor = [UIColor grayColor];
}

//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [self.recevieIDBtn setTitle:@"获取验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [_timer_show removeFromSuperview];//移除倒计时模块
    self.recevieIDBtn.userInteractionEnabled = YES;//按钮可以点击
    self.recevieIDBtn.backgroundColor = self.recevieIDBtnColor;
}



@end
