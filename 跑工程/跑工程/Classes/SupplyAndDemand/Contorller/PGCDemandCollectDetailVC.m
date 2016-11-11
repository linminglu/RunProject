//
//  PGCDemandCollectDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandCollectDetailVC.h"
#import "PGCDetailSubviewTop.h"
#import "PGCDetailSubviewBottom.h"


@interface PGCDemandCollectDetailVC ()  <PGCDetailSubviewBottomDelegate>
/**
 版块0 底部滚动视图
 */
@property (strong, nonatomic) UIScrollView *scrollView;
/**
 板块视图1
 */
@property (strong, nonatomic) PGCDetailSubviewTop *topView;
/**
 板块视图2
 */
@property (strong, nonatomic) PGCDetailSubviewBottom *bottomView;

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCDemandCollectDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
  
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"需求信息详情";
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = RGB(244, 244, 244);
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.scrollView];
    
    NSDictionary *model = @{@"title":@[@"标题：",
                                       @"时间：",
                                       @"采购单位（个人）：",
                                       @"地址：",
                                       @"地区：",
                                       @"需求："],
                            @"content":@[@"需要什么样的东西或者是机械服务",
                                         @"2016年09月30号   到   2017年11月30号",
                                         @"重庆市什么区什么什么路",
                                         @"重庆市什么区什么什么路",
                                         @"当前位置",
                                         @"点击选择"]};
    // 版块1
    self.topView = [[PGCDetailSubviewTop alloc] initWithModel:model];
    [self.scrollView addSubview:self.topView];
    
    // 版块2
    self.bottomView = [[PGCDetailSubviewBottom alloc] initWithModel:nil];
    self.bottomView.delegate = self;
    [self.scrollView addSubview:self.bottomView];
    
    [self setPlateViewAutoLayout];
}


#pragma mark - 三方约束子控件

- (void)setPlateViewAutoLayout {
    
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


#pragma mark - PGCDetailSubviewBottomDelegate

- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom checkMoreContact:(UIButton *)checkMoreContact {
    
}

- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom callPhone:(UIButton *)callPhone {
    
}


#pragma mark - PGCSupplyAndDemandShareViewDelegate

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqFriend:(UIButton *)qqFriend {
    [PGCProgressHUD showMessage:@"分享需求信息到QQ好友成功!" inView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqZone:(UIButton *)qqZone {
    [PGCProgressHUD showMessage:@"分享需求信息到QQ空间成功!" inView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChat:(UIButton *)weChat {
    [PGCProgressHUD showMessage:@"分享需求信息到微信好友成功!" inView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChatFriends:(UIButton *)friends {
    [PGCProgressHUD showMessage:@"分享需求信息到朋友圈成功!" inView:self.view];
}


@end
