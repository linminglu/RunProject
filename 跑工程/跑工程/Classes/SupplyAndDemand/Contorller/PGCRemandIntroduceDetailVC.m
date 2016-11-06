//
//  PGCRemandIntroduceDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCRemandIntroduceDetailVC.h"
#import "PGCIntroduceDetailTopView.h"
#import "PGCIntroduceDetailBottomView.h"
#import "PGCAreaAndTypeRootVC.h"

@interface PGCRemandIntroduceDetailVC () <PGCIntroduceDetailTopViewDelegate, PGCIntroduceDetailBottomViewDelegate>
/**
 版块0 底部滚动视图
 */
@property (strong, nonatomic) UIScrollView *scrollView;
/**
 板块视图1
 */
@property (strong, nonatomic) PGCIntroduceDetailTopView *topView;
/**
 板块视图2
 */
@property (strong, nonatomic) PGCIntroduceDetailBottomView *bottomView;
/**
 底部发布按钮
 */
@property (strong, nonatomic) UIButton *introduceBtn;

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCRemandIntroduceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"需求信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = RGB(244, 244, 244);
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.scrollView];
    
    
    // 版块1
    self.topView = [[PGCIntroduceDetailTopView alloc] initWithModel:nil];
    self.topView.delegate = self;
    [self.scrollView addSubview:self.topView];
    
    
    // 版块2
    self.bottomView = [[PGCIntroduceDetailBottomView alloc] initWithModel:nil];
    self.bottomView.delegate = self;
    [self.scrollView addSubview:self.bottomView];
    
    
    // 发布按钮
    self.introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.introduceBtn.backgroundColor = PGCTintColor;
    [self.introduceBtn setTitle:@"重新发布" forState:UIControlStateNormal];
    [self.introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.introduceBtn addTarget:self action:@selector(respondsToReIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.introduceBtn];
    
    [self setPlateViewAutoLayout];
    
}


#pragma mark - 三方约束子控件

- (void)setPlateViewAutoLayout
{
    self.introduceBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(TAB_BAR_HEIGHT);
    
    
    self.scrollView.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.introduceBtn, 0);
    
    
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

- (void)respondsToReIntroduceBtn:(UIButton *)sender {
    
}


#pragma mark - PGCIntroduceDetailTopViewDelegate

- (void)introduceDetailTopView:(PGCIntroduceDetailTopView *)topView selectArea:(UIButton *)sender
{
    PGCAreaAndTypeRootVC *vc = [[PGCAreaAndTypeRootVC alloc] init];
    vc.navigationItem.title = @"地区";
    
    [self.navigationController pushViewController:vc animated:true];
}

- (void)introduceDetailTopView:(PGCIntroduceDetailTopView *)topView slectDemand:(UIButton *)demand
{
    PGCAreaAndTypeRootVC *vc = [[PGCAreaAndTypeRootVC alloc] init];
    vc.navigationItem.title = @"需求";
    
    [self.navigationController pushViewController:vc animated:true];
}


#pragma mark - PGCIntroduceDetailBottomViewDelegate

- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView deleteContact:(UIButton *)deleteContact {
    
}

- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView addContact:(UIButton *)addContact {
    
}

- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView addImage:(UIButton *)addImage {
    
}

- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView deleteImage:(UIButton *)deleteImage {
    
}


@end
