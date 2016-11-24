//
//  PGCProfileController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProfileController.h"
#import "PGCRegisterController.h"
#import "PGCLoginController.h"
#import "PGCResetPasswordController.h"
#import "PGCSettingController.h"
#import "PGCUserInfoController.h"
#import "PGCShareToFriendController.h"
#import "PGCProfileAPIManager.h"
#import "PGCRegisterOrLoginAPIManager.h"
#import "PGCPhotoBrowser.h"
#import "PGCHeadImage.h"

@interface PGCProfileController ()
{
    BOOL _isLogin;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginAndRegisterBtn;

- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCProfileController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = false;
}

- (void)dealloc {
    [PGCNotificationCenter removeObserver:self name:kProfileNotification object:nil];
    [PGCNotificationCenter removeObserver:self name:kReloadProfileInfo object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeUserInterface
{    
    self.headImageView.layer.masksToBounds = true;
    self.headImageView.layer.cornerRadius = 65 / 2;
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    _isLogin = user ? true : false;
    
    // 判断当前是否登录
    if (_isLogin) {
        // 用户已登录，加载用户头像和名字
        [self.loginAndRegisterBtn setTitle:user.name forState:UIControlStateNormal];
        // 用户头像
        self.headImageView.userInteractionEnabled = true;
        NSURL *url = [NSURL URLWithString:[kBaseImageURL stringByAppendingString:user.headimage]];
        [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
    } else {
        [self.loginAndRegisterBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        self.headImageView.userInteractionEnabled = false;
        [self.headImageView setImage:[UIImage imageNamed:@"头像"]];
    }
}

- (void)registerNotification
{
    [PGCNotificationCenter addObserver:self selector:@selector(profileNotification:) name:kProfileNotification object:nil];
    [PGCNotificationCenter addObserver:self selector:@selector(reloadProfileInfo:) name:kReloadProfileInfo object:nil];
}


#pragma mark - NSNotificationCenter
- (void)profileNotification:(NSNotification *)notifi
{
    if (notifi.object) {
        [self.navigationController pushViewController:notifi.object animated:false];
    }
}


- (void)reloadProfileInfo:(NSNotification *)notifi
{
    if ([notifi.userInfo objectForKey:@"Logout"]) {// 收到用户退出登录的通知
        _isLogin = false;
        self.headImageView.userInteractionEnabled = false;
        [self.headImageView setImage:[UIImage imageNamed:@"头像"]];
        [self.loginAndRegisterBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        return;
    }
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    if ([notifi.userInfo objectForKey:@"Login"]) {// 收到用户登录的通知
        _isLogin = true;
        [self.loginAndRegisterBtn setTitle:user.name forState:UIControlStateNormal];
        self.headImageView.userInteractionEnabled = true;
        NSURL *url = [NSURL URLWithString:[kBaseImageURL stringByAppendingString:user.headimage]];
        [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
        return;
    }
    if ([notifi.userInfo objectForKey:@"HeadImage"]) {// 收到用户修改头像的通知
        
        PGCHeadImage *headImage = [notifi.userInfo objectForKey:@"HeadImage"];
        NSDictionary *params = @{@"user_id":@(user.user_id),
                                 @"token":manager.token.token,
                                 @"client_type":@"iphone",
                                 @"headimage":headImage.path};
        [PGCProfileAPIManager completeInfoRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            
            if (status == RespondsStatusSuccess) {
                [manager readTokenData];
                NSString *imageStr = manager.token.user.headimage;
                NSURL *url = [NSURL URLWithString:[kBaseImageURL stringByAppendingString:imageStr]];
                [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
                
            } else {
                [PGCProgressHUD showMessage:message toView:self.view];
                
                if (status == RespondsStatusDataError) {
                    PGCLoginController *loginVC = [[PGCLoginController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:true];
                }
            }
        }];
    }
}


#pragma mark - Gesture
/**
 头像, 未登录前不能点击
 */
- (IBAction)iconGesture:(UITapGestureRecognizer *)sender
{
    if (!_isLogin) {
        return;
    } else {
        PGCManager *manager = [PGCManager manager];
        [manager readTokenData];
        PGCUser *user = manager.token.user;
        
        PGCPhoto *photo = [[PGCPhoto alloc] init];
        photo.url = [kBaseImageURL stringByAppendingString:user.headimage];
        photo.thumbUrl = [kBaseImageURL stringByAppendingString:user.headimage];
        photo.scrRect = [self.headImageView convertRect:self.headImageView.bounds toView:nil];
        
        PGCPhotoBrowser *brower = [[PGCPhotoBrowser alloc] init];
        brower.photos = @[photo];
        brower.selectedIndex = 0;
        [brower show];
    }
}


#pragma mark - Event
/**
 登录/注册 block回调登录信息
 */
- (IBAction)iconLabelButtonClick:(UIButton *)sender
{
    if (!_isLogin) {
        PGCLoginController *loginVC = [[PGCLoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:true];
    } else {
        PGCUserInfoController *userInfoVC = [[PGCUserInfoController alloc] init];
        [self.navigationController pushViewController:userInfoVC animated:true];
    }
}

/**
 个人中心
 */
- (IBAction)userInfoButtonClick:(UIButton *)sender
{
    PGCUserInfoController *userInfoVC = [[PGCUserInfoController alloc] init];
    
    if (_isLogin) {
        [self.navigationController pushViewController:userInfoVC animated:true];
    } else {
        PGCLoginController *loginVC = [[PGCLoginController alloc] init];
        loginVC.vc = userInfoVC;
        [self.navigationController pushViewController:loginVC animated:true];
    }
}

/**
 设置
 */
- (IBAction)settingButtonClick:(UIButton *)sender
{
    PGCSettingController *settingVC = [[PGCSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:true];
}

/**
 推荐给好友
 */
- (IBAction)commendToFriendButtonClick:(UIButton *)sender
{
    PGCShareToFriendController *shareVC = [[PGCShareToFriendController alloc] init];
    [self.navigationController pushViewController:shareVC animated:true];
}

/**
 修改密码按钮
 */
- (IBAction)updataPassWordButtonClick:(UIButton *)sender
{
    PGCResetPasswordController *resetPassVC = [[PGCResetPasswordController alloc] init];
    resetPassVC.navigationItem.title = @"修改密码";
    [self.navigationController pushViewController:resetPassVC animated:true];
}

/**
 会员中心

 @param sender
 */
- (IBAction)VIPInfoButtonClick:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user.is_vip) {
        [PGCProgressHUD showMessage:@"请先购买VIP" toView:self.view];
    }
}


@end
