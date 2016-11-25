//
//  PGCProfileController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProfileController.h"
#import "PGCProfileCell.h"
#import "PGCRegisterController.h"
#import "PGCLoginController.h"
#import "PGCContactsController.h"
#import "PGCResetPasswordController.h"
#import "PGCSettingController.h"
#import "PGCUserInfoController.h"
#import "PGCShareToFriendController.h"
#import "PGCProfileAPIManager.h"
#import "PGCPhotoBrowser.h"
#import "PGCHeadImage.h"

@interface PGCProfileController ()
{
    BOOL _isLogin;
}

@property (nonatomic, weak) UIImageView *lineView;/** 导航栏下的黑线 */
@property (strong, nonatomic) UIView *backView;/** 背景视图 */
@property (strong, nonatomic) UIImageView *headImageView;/** 头像 */
@property (strong, nonatomic) UIButton *loginAndRegisterBtn;/** 登录按钮 */
@property (strong, nonatomic) UIScrollView *scrollView;/** 背景滚动视图 */
@property (strong, nonatomic) PGCProfileCell *profile;/** 个人中心 */
@property (strong, nonatomic) PGCProfileCell *contact;/** 通讯录 */
@property (strong, nonatomic) PGCProfileCell *setting;/** 设置 */
@property (strong, nonatomic) PGCProfileCell *shareApp;/** 推荐app */
@property (strong, nonatomic) PGCProfileCell *setPassword;/** 修改密码 */
@property (strong, nonatomic) PGCProfileCell *vipCenter;/** 会员中心 */

- (void)initializeUserInterface; /** 初始化用户界面 */
- (void)registerNotification; /** 注册通知 */

@end

@implementation PGCProfileController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.scrollView];
    
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

- (void)registerNotification {
    [PGCNotificationCenter addObserver:self selector:@selector(profileNotification:) name:kProfileNotification object:nil];
    [PGCNotificationCenter addObserver:self selector:@selector(reloadProfileInfo:) name:kReloadProfileInfo object:nil];
}

//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
- (void)iconGesture:(UITapGestureRecognizer *)sender
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
- (void)iconLabelButtonClick:(UIButton *)sender
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
- (void)userInfoButtonClick:(UIButton *)sender
{
    PGCUserInfoController *userInfoVC = [[PGCUserInfoController alloc] init];
    
    if (_isLogin) {
        [self.navigationController pushViewController:userInfoVC animated:true];
    } else {
        [MBProgressHUD showError:@"请先登录" complete:^{
            PGCLoginController *loginVC = [[PGCLoginController alloc] init];
            loginVC.vc = userInfoVC;
            [self.navigationController pushViewController:loginVC animated:true];
        }];
    }
}

/**
 通讯录
 */
- (void)contactButtonClick:(UIButton *)sender
{
    PGCContactsController *contactVC = [[PGCContactsController alloc] init];
    
    if (_isLogin) {
        [self.navigationController pushViewController:contactVC animated:true];
    } else {
        [MBProgressHUD showError:@"请先登录" complete:^{
            PGCLoginController *loginVC = [[PGCLoginController alloc] init];
            loginVC.vc = contactVC;
            [self.navigationController pushViewController:loginVC animated:true];
        }];
    }
}

/**
 设置
 */
- (void)settingButtonClick:(UIButton *)sender
{
    PGCSettingController *settingVC = [[PGCSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:true];
}

/**
 推荐给好友
 */
- (void)commendToFriendButtonClick:(UIButton *)sender
{
    PGCShareToFriendController *shareVC = [[PGCShareToFriendController alloc] init];
    [self.navigationController pushViewController:shareVC animated:true];
}

/**
 修改密码按钮
 */
- (void)updataPassWordButtonClick:(UIButton *)sender
{
    PGCResetPasswordController *resetPassVC = [[PGCResetPasswordController alloc] init];
    resetPassVC.navigationItem.title = @"修改密码";
    [self.navigationController pushViewController:resetPassVC animated:true];
}

/**
 会员中心
 */
- (void)VIPInfoButtonClick:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user.is_vip) {
        [MBProgressHUD showError:@"请先购买VIP" toView:self.view];
    }
}


#pragma mark - Getter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        _backView.backgroundColor = RGB(249, 136, 46);
        
        [_backView addSubview:self.headImageView];
        self.headImageView.sd_layout
        .centerXIs(SCREEN_WIDTH / 2)
        .topSpaceToView(_backView, 60)
        .heightIs(66)
        .widthEqualToHeight();
        self.headImageView.layer.masksToBounds = true;
        self.headImageView.layer.cornerRadius = self.headImageView.width_sd / 2;
        
        [_backView addSubview:self.loginAndRegisterBtn];
        self.loginAndRegisterBtn.sd_layout
        .centerXEqualToView(self.headImageView)
        .topSpaceToView(self.headImageView, 10)
        .widthIs(80)
        .heightIs(20);
    }
    return _backView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconGesture:)]];
    }
    return _headImageView;
}

- (UIButton *)loginAndRegisterBtn {
    if (!_loginAndRegisterBtn) {
        _loginAndRegisterBtn = [[UIButton alloc] init];
        [_loginAndRegisterBtn.titleLabel setFont:SetFont(14)];
        [_loginAndRegisterBtn addTarget:self action:@selector(iconLabelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginAndRegisterBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.backView.bottom_sd, SCREEN_WIDTH, SCREEN_HEIGHT - self.backView.bottom_sd)];
        _scrollView.backgroundColor = PGCBackColor;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        [_scrollView addSubview:self.profile];
        [_scrollView addSubview:self.contact];
        [_scrollView addSubview:self.setting];
        [_scrollView addSubview:self.shareApp];
        [_scrollView addSubview:self.setPassword];
        [_scrollView addSubview:self.vipCenter];
        [_scrollView setupAutoContentSizeWithBottomView:self.vipCenter bottomMargin:TAB_BAR_HEIGHT + 15];
    }
    return _scrollView;
}

- (PGCProfileCell *)profile {
    if (!_profile) {
        _profile = [[PGCProfileCell alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 45)];
        _profile.titleImageName = @"个人中心";
        _profile.title = @"个人中心";
        _profile.isShow = false;
        [_profile addTarget:self event:@selector(userInfoButtonClick:)];
    }
    return _profile;
}

- (PGCProfileCell *)contact {
    if (!_contact) {
        _contact = [[PGCProfileCell alloc] initWithFrame:CGRectMake(0, self.profile.bottom_sd + 15, SCREEN_WIDTH, 45)];
        _contact.titleImageName = @"通讯录";
        _contact.title = @"通讯录";
        _contact.isShow = false;
        [_contact addTarget:self event:@selector(contactButtonClick:)];
    }
    return _contact;
}


- (PGCProfileCell *)setting {
    if (!_setting) {
        _setting = [[PGCProfileCell alloc] initWithFrame:CGRectMake(0, self.contact.bottom_sd + 15, SCREEN_WIDTH, 45)];
        _setting.titleImageName = @"设置";
        _setting.title = @"设置";
        _setting.isShow = false;
        [_setting addTarget:self event:@selector(settingButtonClick:)];
    }
    return _setting;
}



- (PGCProfileCell *)shareApp {
    if (!_shareApp) {
        _shareApp = [[PGCProfileCell alloc] initWithFrame:CGRectMake(0, self.setting.bottom_sd + 15, SCREEN_WIDTH, 45)];
        _shareApp.titleImageName = @"推荐给好友";
        _shareApp.title = @"推荐给好友";
        _shareApp.isShow = false;
        [_shareApp addTarget:self event:@selector(commendToFriendButtonClick:)];
    }
    return _shareApp;
}


- (PGCProfileCell *)setPassword {
    if (!_setPassword) {
        _setPassword = [[PGCProfileCell alloc] initWithFrame:CGRectMake(0, self.shareApp.bottom_sd + 15, SCREEN_WIDTH, 45)];
        _setPassword.titleImageName = @"修改密码";
        _setPassword.title = @"修改密码";
        _setPassword.isShow = false;
        [_setPassword addTarget:self event:@selector(updataPassWordButtonClick:)];
    }
    return _setPassword;
}

- (PGCProfileCell *)vipCenter {
    if (!_vipCenter) {
        _vipCenter = [[PGCProfileCell alloc] initWithFrame:CGRectMake(0, self.setPassword.bottom_sd + 15, SCREEN_WIDTH, 45)];
        _vipCenter.titleImageName = @"会员中心";
        _vipCenter.title = @"会员中心";
        _vipCenter.isShow = true;
        _vipCenter.detailTitle = @"开通会员，畅想更多优惠";
        [_vipCenter addTarget:self event:@selector(VIPInfoButtonClick:)];
    }
    return _vipCenter;
}


@end
