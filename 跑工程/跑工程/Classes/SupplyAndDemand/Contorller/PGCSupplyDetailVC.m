//
//  PGCSupplyDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyDetailVC.h"
#import "PGCDetailSubviewTop.h"
#import "PGCSupplySubviewTop.h"
#import "PGCDetailSubviewBottom.h"
#import "PGCSupply.h"
#import "PGCSupplyAndDemandAPIManager.h"
#import "PGCSupplyAndDemandShareView.h"
#import "PGCNavigationItem.h"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ShareBtnTag,
    HeartBtnTag
};

@interface PGCSupplyDetailVC ()  <PGCDetailSubviewBottomDelegate, PGCSupplyAndDemandShareViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;/** 版块0 底部滚动视图 */
@property (strong, nonatomic) PGCSupplySubviewTop *topView;/** 板块视图1 */
@property (strong, nonatomic) PGCDetailSubviewBottom *bottomView;/** 板块视图2 */


- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSupplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"供应信息详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = RGB(244, 244, 244);
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.scrollView];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Types *type in self.supply.types) {
        [mutableArray addObject:type.name];
    }
    NSArray *array = @[self.supply.title,
                       self.supply.company,
                       self.supply.address,
                       [self.supply.province stringByAppendingString:self.supply.city],
                       [mutableArray componentsJoinedByString:@","]];
    NSDictionary *model = @{@"title":@[@"标题：",
                                       @"供应商家：",
                                       @"地址：",
                                       @"地区：",
                                       @"类别："],
                            @"content":array};
    // 版块1
    self.topView = [[PGCSupplySubviewTop alloc] initWithModel:model];
    [self.scrollView addSubview:self.topView];
    
    // 版块2
    self.bottomView = [[PGCDetailSubviewBottom alloc] initWithModel:nil];
    self.bottomView.delegate = self;
    [self.scrollView addSubview:self.bottomView];
    
    [self setPlateViewAutoLayout];
}


#pragma mark - 三方约束子控件

- (void)setPlateViewAutoLayout
{
    self.scrollView.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    // 第1个版块布局
    self.topView.sd_layout
    .topSpaceToView(self.scrollView, 0)
    .leftSpaceToView(self.scrollView, 0)
    .rightSpaceToView(self.scrollView, 0)
    .heightIs(10);// 给定初始高度，后面根据自身子视图计算高度
    
    // 第2个版块布局
    self.bottomView.sd_layout
    .topSpaceToView(self.topView, 0)
    .leftSpaceToView(self.scrollView, 0)
    .rightSpaceToView(self.scrollView, 0)
    .heightIs(10);    
    
    [self.scrollView setupAutoHeightWithBottomView:self.bottomView bottomMargin:0];
}


#pragma mark - Event

- (void)respondsToDetailItem:(PGCNavigationItem *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    if (sender.tag == HeartBtnTag) {
        if (self.supply.collect_id == 0) {
            NSDictionary *params = @{@"user_id":@(user.user_id),
                                     @"client_type":@"iphone",
                                     @"token":manager.token.token,
                                     @"id":@(self.supply.id),
                                     @"type":@(1)};
            [PGCSupplyAndDemandAPIManager addSupplyDemandCollectWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
                if (status == RespondsStatusSuccess) {
                    self.supply.collect_id = [resultData intValue];
                    [PGCProgressHUD showMessage:@"收藏成功" toView:self.view];
                    sender.itemLabel.text = @"取消收藏";
                    [PGCNotificationCenter postNotificationName:kRefreshDemandAndSupplyData object:self.supply userInfo:nil];
                } else {
                    [PGCProgressHUD showMessage:message toView:self.view];
                }
            }];
        } else {
            NSString *ids_json = [NSString stringWithFormat:@"[%d]", self.supply.collect_id];
            NSDictionary *params = @{@"user_id":@(user.user_id),
                                     @"client_type":@"iphone",
                                     @"token":manager.token.token,
                                     @"ids_json":ids_json};
            [PGCSupplyAndDemandAPIManager deleteSupplyDemandCollectWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
                if (status == RespondsStatusSuccess) {
                    self.supply.collect_id = 0;
                    [PGCProgressHUD showMessage:@"已取消收藏" toView:self.view];
                    sender.itemLabel.text = @"收藏";
                    [PGCNotificationCenter postNotificationName:kRefreshDemandAndSupplyData object:self.supply userInfo:nil];
                } else {
                    [PGCProgressHUD showMessage:message toView:self.view];
                }
            }];
        }
    } else {
        PGCSupplyAndDemandShareView *shareView = [[PGCSupplyAndDemandShareView alloc] init];
        shareView.delegate = self;
        [shareView showShareView];
    }
}



#pragma mark - PGCDetailSubviewBottomDelegate

- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom checkMoreContact:(UIButton *)checkMoreContact {
    
}

- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom callPhone:(UIButton *)callPhone {
    
}


#pragma mark - PGCSupplyAndDemandShareViewDelegate

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqFriend:(UIButton *)qqFriend {
    [PGCProgressHUD showMessage:@"分享供应信息到QQ好友成功!" toView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqZone:(UIButton *)qqZone {
    [PGCProgressHUD showMessage:@"分享供应信息到QQ空间成功!" toView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChat:(UIButton *)weChat {
    [PGCProgressHUD showMessage:@"分享供应信息到微信好友成功!" toView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChatFriends:(UIButton *)friends {
    [PGCProgressHUD showMessage:@"分享供应信息到朋友圈成功!" toView:self.view];
}



#pragma mark - Setter

- (void)setSupply:(PGCSupply *)supply
{
    _supply = supply;
    
    NSString *collectBtnTitle = supply.collect_id > 0 ? @"取消收藏" : @"收藏";
    PGCNavigationItem *heartBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"heart"] title:collectBtnTitle];
    heartBtn.bounds = CGRectMake(0, 0, 50, 40);
    heartBtn.itemLabel.textColor = PGCTextColor;
    heartBtn.tag = HeartBtnTag;
    [heartBtn addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    PGCNavigationItem *shareBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"share"] title:@"分享"];
    shareBtn.bounds = CGRectMake(0, 0, 30, 40);
    shareBtn.itemLabel.textColor = PGCTextColor;
    shareBtn.tag = ShareBtnTag;
    [shareBtn addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:shareBtn],
                                                [[UIBarButtonItem alloc] initWithCustomView:heartBtn]];
}

@end
