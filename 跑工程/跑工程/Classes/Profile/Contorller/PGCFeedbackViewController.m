//
//  PGCFeedbackViewController.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCFeedbackViewController.h"
#import "PGCOtherAPIManager.h"
#import "PGCFeedback.h"

@interface PGCFeedbackViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *palceholder;/** 意见输入框提示语 */
@property (weak, nonatomic) IBOutlet UITextView *textView;/** 意见输入框 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;/** 电话输入框 */
@property (weak, nonatomic) IBOutlet UITextField *nameTF;/** 昵称输入框 */
@property (strong, nonatomic) PGCFeedback *feedback;/** 意见反馈模型 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCFeedbackViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSendFeedback:)];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.2;
    self.textView.layer.cornerRadius = 5.0;
}


#pragma mark - Event

- (void)respondsToSendFeedback:(UIBarButtonItem *)sender
{
    [self.view endEditing:true];
    
    if (!(self.textView.text.length > 0)) {
        [PGCProgressHUD showMessage:@"请输入您的反馈意见" toView:self.view];
        return;
    }
    if (!(self.phoneTF.text.length > 0)) {
        [PGCProgressHUD showMessage:@"请输入您的联系方式" toView:self.view];
        return;
    }
    self.feedback.content = self.textView.text;
    self.feedback.phone = self.phoneTF.text;
    if (self.nameTF.text.length > 0) {
        self.feedback.name = self.nameTF.text;
    }
    
    MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:nil];
    NSDictionary *params = [self.feedback mj_keyValues];
    [PGCOtherAPIManager feedbackRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [hud hideAnimated:true];
        
        if (status == RespondsStatusSuccess) {
            [PGCProgressHUD showAlertWithTitle:@"感谢您的反馈！" block:^{
                [self.navigationController popViewControllerAnimated:true];
            }];
        } else {
            [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
            }];
        }
    }];
}



#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.palceholder.text = @"请填写您的反馈意见";
    } else {
        self.palceholder.text = @"";
    }
}


#pragma mark - Getter

- (PGCFeedback *)feedback {
    if (!_feedback) {
        _feedback = [[PGCFeedback alloc] init];
    }
    return _feedback;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}


@end
