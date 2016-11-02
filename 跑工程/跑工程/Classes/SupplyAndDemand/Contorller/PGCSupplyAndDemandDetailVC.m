//
//  PGCSupplyAndDemandDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandDetailVC.h"
#import "PGCSupplyAndDemandShareView.h"

#define BarItemTag 86

@interface PGCSupplyAndDemandDetailVC () <PGCSupplyAndDemandShareViewDelegate>

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSupplyAndDemandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}


#pragma mark - Init

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *shareBtn = [self barItem:[UIImage imageNamed:@"share"] title:@"分享"];
    shareBtn.tag = BarItemTag;
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    UIButton *heartBtn = [self barItem:[UIImage imageNamed:@"heart"] title:@"收藏"];
    heartBtn.tag = BarItemTag + 1;
    UIBarButtonItem *heartItem = [[UIBarButtonItem alloc] initWithCustomView:heartBtn];
    
    self.navigationItem.rightBarButtonItems = @[shareItem, heartItem];
    
    
    [self setupSubviews];
}

- (UIButton *)barItem:(UIImage *)image title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 40, 40);
    [button setImage:image forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.width, -button.imageView.height, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-[button.titleLabel intrinsicContentSize].height, 0, 0, -[button.titleLabel intrinsicContentSize].width);
    
    return button;
}


#pragma mark - View

- (void)setupSubviews {
    
}



#pragma mark - Events

- (void)respondsToDetailItem:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case BarItemTag:
        {
            PGCSupplyAndDemandShareView *shareView = [[PGCSupplyAndDemandShareView alloc] init];
            shareView.delegate = self;
            [shareView showShareView];
        }
            break;
        case BarItemTag + 1:
        {
            [self showHUDWith:self.view title:@"收藏成功!"];
        }
            break;
        default:
            break;
    }
}

- (void)showHUDWith:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    
    [hud hideAnimated:true afterDelay:1.5f];
}


#pragma mark - PGCSupplyAndDemandShareViewDelegate

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqFriend:(UIButton *)qqFriend {
    [self showHUDWith:self.view title:@"分享到QQ好友成功!"];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqZone:(UIButton *)qqZone {
    [self showHUDWith:self.view title:@"分享到QQ空间成功!"];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChat:(UIButton *)weChat {
    [self showHUDWith:self.view title:@"分享到微信好友成功!"];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChatFriends:(UIButton *)friends {
    [self showHUDWith:self.view title:@"分享到朋友圈成功!"];
}


#pragma mark - Setter

- (void)setDetailVCTitle:(NSString *)detailVCTitle {
    _detailVCTitle = detailVCTitle;
    
    self.navigationItem.title = detailVCTitle;
}


@end
