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
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"
#import "UIButton+WebCache.h"
#import "PGCProfileAPIManager.h"
#import "PGCHeadImage.h"

@interface PGCProfileController ()

@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginAndRegisterBtn;


- (void)initializeDataSource; /** 初始化数据源 */
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
    
    [self initializeDataSource];
    [self initializeUserInterface];
    [self registerNotification];
}

- (void)initializeDataSource {

}

- (void)initializeUserInterface {
    
    self.headImageBtn.layer.masksToBounds = true;
    self.headImageBtn.layer.cornerRadius = 65 / 2;
    
    [[PGCTokenManager tokenManager] readAuthorizeData];
    PGCUserInfo *user = [PGCTokenManager tokenManager].token.user;
    
    // 判断当前是否登录
    if (user) {
        // 用户已登录，加载用户头像和名字
        self.loginAndRegisterBtn.enabled = false;
        [self.loginAndRegisterBtn setTitle:user.name forState:UIControlStateNormal];
        
        if (user.headimage) {
            NSURL *url = [NSURL URLWithString:user.headimage];
            [self.headImageBtn sd_setImageWithURL:url forState:UIControlStateNormal];
        }
    } else {
        
        [self.loginAndRegisterBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [self.headImageBtn setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
    }
}

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(profileNotification:) name:kProfileNotification object:nil];
    [PGCNotificationCenter addObserver:self selector:@selector(reloadProfileInfo:) name:kReloadProfileInfo object:nil];
}


#pragma mark - NSNotificationCenter
- (void)profileNotification:(NSNotification *)notifi {
    
    if (notifi.object) {
        [self.navigationController pushViewController:notifi.object animated:false];
    }
}


- (void)reloadProfileInfo:(NSNotification *)notifi {
    
    [[PGCTokenManager tokenManager] readAuthorizeData];
    
    if ([notifi.userInfo objectForKey:@"Login"]) {// 收到用户登录的通知
        PGCUserInfo *user = [PGCTokenManager tokenManager].token.user;
        
        self.loginAndRegisterBtn.enabled = false;
        [self.loginAndRegisterBtn setTitle:user.name forState:UIControlStateNormal];
        
        if (user.headimage) {
            NSURL *url = [NSURL URLWithString:user.headimage];
            [self.headImageBtn sd_setImageWithURL:url forState:UIControlStateNormal];
        }
    }
    
    if ([notifi.userInfo objectForKey:@"Logout"]) {// 收到用户退出登录的通知
        
        self.loginAndRegisterBtn.enabled = true;
        [self.loginAndRegisterBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [self.headImageBtn setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
    }
    
    if ([notifi.userInfo objectForKey:@"HeadImage"]) {// 收到用户修改头像的通知
        PGCHeadImage *image = [notifi.userInfo objectForKey:@"HeadImage"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"iphone" forKey:@"client_type"];
        [parameters setObject:[PGCTokenManager tokenManager].token.token forKey:@"token"];
        [parameters setObject:@([PGCTokenManager tokenManager].token.user.id) forKey:@"user_id"];
        [parameters setObject:image.path forKey:@"headimage"];
        
        [PGCProfileAPIManager completeInfoRequestWithParameters:parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            
        }];
    }
}

#pragma mark - Event

/**
 头像, 未登录前不能点击

 @param sender
 */
- (IBAction)iconButtonClick:(UIButton *)sender {
    [[PGCTokenManager tokenManager] readAuthorizeData];
    PGCUserInfo *user = [PGCTokenManager tokenManager].token.user;
    if (!user) {
        PGCLoginController *loginVC = [[PGCLoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:true];
    }
    PGCUserInfoController *userInfoVC = [[PGCUserInfoController alloc] init];
    [self.navigationController pushViewController:userInfoVC animated:true];
}

/**
 登录/注册 block回调登录信息

 @param sender
 */
- (IBAction)iconLabelButtonClick:(UIButton *)sender {
    PGCLoginController *loginVC = [[PGCLoginController alloc] init];
    [self.navigationController pushViewController:loginVC animated:true];
}

/**
 个人中心

 @param sender
 */
- (IBAction)userInfoButtonClick:(UIButton *)sender {
    PGCUserInfoController *userInfoVC = [[PGCUserInfoController alloc] init];
    PGCUserInfo *user = [PGCTokenManager tokenManager].token.user;
    
    if (user) {
        [self.navigationController pushViewController:userInfoVC animated:true];
    } else {
        PGCLoginController *loginVC = [[PGCLoginController alloc] init];
        loginVC.vc = userInfoVC;
        [self.navigationController pushViewController:loginVC animated:true];
    }
}

/**
 设置

 @param sender
 */
- (IBAction)settingButtonClick:(UIButton *)sender {
    PGCSettingController *settingVC = [[PGCSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:true];
}

/**
 推荐给好友

 @param send
 */
- (IBAction)commendToFriendButtonClick:(UIButton *)sender {
    PGCShareToFriendController *shareVC = [[PGCShareToFriendController alloc] init];
    [self.navigationController pushViewController:shareVC animated:true];
}

/**
 修改密码按钮

 @param sender
 */
- (IBAction)updataPassWordButtonClick:(UIButton *)sender {
    PGCResetPasswordController *resetPassVC = [[PGCResetPasswordController alloc] init];
    resetPassVC.navigationItem.title = @"修改密码";
    [self.navigationController pushViewController:resetPassVC animated:true];
}

/**
 会员中心

 @param sender
 */
- (IBAction)VIPInfoButtonClick:(UIButton *)sender {
    [PGCProgressHUD showMsgWithoutView:@"VIP用户"];
}


@end
