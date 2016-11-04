//
//  PGCDemandIntroduceInfoVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandIntroduceInfoVC.h"

@interface PGCDemandIntroduceInfoVC ()

/**
 版块0 底部滚动视图
 */
@property (strong, nonatomic) UIScrollView *scrollView;
/**
 底部发布按钮
 */
@property (strong, nonatomic) UIButton *introduceBtn;

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCDemandIntroduceInfoVC

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
    
    // 发布按钮
    self.introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.introduceBtn.backgroundColor = PGCTintColor;
    [self.introduceBtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.introduceBtn addTarget:self action:@selector(respondsToIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    
    
}


#pragma mark - Event

- (void)respondsToIntroduceBtn:(UIButton *)sender {
    
}

@end
