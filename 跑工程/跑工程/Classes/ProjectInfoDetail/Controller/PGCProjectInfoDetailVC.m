//
//  PGCProjectInfoDetailViewController.m
//  跑工程
//
//  Created by leco on 2016/10/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoDetailVC.h"
#import "PGCProjectSurveyScrollView.h"
#import "PGCProjectContactScrollView.h"
#import "PGCMapTypeViewController.h"
#import "PGCProjectInfo.h"
#import "PGCProjectInfoAPIManager.h"
#import "PGCProjectContact.h"

#define SegmentBtnTag 100

@interface PGCProjectInfoDetailVC () <UICollectionViewDataSource>

@property (strong, nonatomic) UIButton *navButton;/** 导航栏按钮 */
@property (strong, nonatomic) UICollectionView *collectionView;/** 集合视图 */
@property (strong, nonatomic) UIButton *previousBtn;/** 当前选中按钮 */
@property (strong, nonatomic) NSMutableArray *segmentBtns;/** 存放按钮的数组 */
@property (strong, nonatomic) UIView *projectTitleView;/** 项目名称背景视图 */
@property (copy, nonatomic) NSArray *contactData;/** 联系人数据源 */
@property (strong, nonatomic) NSMutableDictionary *accessOrCollectParams;/** 添加收藏或浏览记录的参数 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface;/** 初始化用户界面 */

@end

@implementation PGCProjectInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}


- (void)initializeDataSource
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        return;
    }
    NSDictionary *params = @{@"project_id":@(self.projectInfoDetail.id), @"user_id":@(user.user_id)};
    
    [PGCProjectInfoAPIManager getProjectContactsRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        if (status == RespondsStatusSuccess) {
            self.contactData = resultData;
        }
    }];
    self.accessOrCollectParams = [@{@"user_id":@(user.user_id),
                                  @"client_type":@"iphone",
                                  @"token":manager.token.token,
                                  @"project_id":@(self.projectInfoDetail.id),
                                  @"type":@(1)} mutableCopy];
    [PGCProjectInfoAPIManager addAccessOrCollectRequestWithParameters:self.accessOrCollectParams responds:^(RespondsStatus status, NSString *message, id resultData) {
        
    }];
}


- (void)initializeUserInterface
{
    self.navigationItem.title = @"项目详情";
    self.view.backgroundColor = RGB(244, 244, 244);
    
    // 项目详情的三个选择按钮
    CGFloat buttonWidth = (SCREEN_WIDTH - 2) / 3;
    NSArray *btnTitles = @[@"项目概况", @"联系人", @"地图模式"];
    
    for (int i = 0; i < btnTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * (buttonWidth + 1), STATUS_AND_NAVIGATION_HEIGHT, buttonWidth, 39);
        button.backgroundColor = [UIColor whiteColor];
        button.tag = SegmentBtnTag + i;
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(respondsToSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        [self.segmentBtns addObject:button];
    }
    [self updateSegmentButton:self.segmentBtns[0] isSelected:true];
    
    UIView *projectTitleView = [[UIView alloc] init];
    projectTitleView.backgroundColor = [UIColor whiteColor];
    self.projectTitleView = projectTitleView;
    [self.view addSubview:projectTitleView];
    projectTitleView.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT + 40)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(50);
    
    // 项目名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = SetFont(16);
    nameLabel.textColor = PGCTextColor;
    nameLabel.text = self.projectInfoDetail.name;
    [projectTitleView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerYEqualToView(projectTitleView)
    .leftSpaceToView(projectTitleView, 15)
    .rightSpaceToView(projectTitleView, 15)
    .autoHeightRatio(0);
}


#pragma mark - Events

- (void)respondsToSegmentButton:(UIButton *)sender
{
    [self updateSegmentButton:sender isSelected:true];
}

- (void)updateSegmentButton:(UIButton *)button isSelected:(BOOL)selected
{
    if ((self.previousBtn != nil) && (self.previousBtn != button)) {
        [self.previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [button setTitleColor:RGB(250, 117, 10) forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        self.previousBtn = button;
        NSInteger index = (button.tag - SegmentBtnTag);
        if (selected && index < 2) {
            self.collectionView.contentOffset = CGPointMake(index * self.collectionView.width_sd, 0);
        } else {
            [self.navigationController pushViewController:[PGCMapTypeViewController new] animated:true];
        }
    }];
}

/**
 收藏此项目按钮的点击事件

 @param sender
 */
- (void)respondsToCollect:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        [PGCProgressHUD showMessage:@"请先登录" toView:self.view];
        return;
    }
    if (self.projectInfoDetail.collect_id == 0) {
        
        [self.accessOrCollectParams setObject:@(2) forKey:@"type"];
        
        [PGCProjectInfoAPIManager addAccessOrCollectRequestWithParameters:self.accessOrCollectParams responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                
                [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
                [PGCProgressHUD showMessage:@"收藏成功" toView:self.view];
                [PGCNotificationCenter postNotificationName:kRefreshCollectTable object:nil userInfo:nil];
            } else {
                [PGCProgressHUD showMessage:message toView:self.view afterDelayTime:1.5];
            }
        }];
    } else {
        NSString *ids_json = [NSString stringWithFormat:@"[%d]", self.projectInfoDetail.collect_id];
        NSDictionary *params = @{@"user_id":@(user.user_id),
                                 @"client_type":@"iphone",
                                 @"token":manager.token.token,
                                 @"ids_json":ids_json};
        [PGCProjectInfoAPIManager deleteAccessOrCollectRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                
                [sender setTitle:@"收藏此项目" forState:UIControlStateNormal];
                [PGCProgressHUD showMessage:@"已取消收藏" toView:self.view];
                [PGCNotificationCenter postNotificationName:kRefreshCollectTable object:nil userInfo:nil];
            } else {
                [PGCProgressHUD showMessage:message toView:self.view afterDelayTime:1.5];
            }
        }];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        PGCProjectSurveyScrollView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProjectSurveyScrollView forIndexPath:indexPath];
        if (!cell) {
            cell = [[PGCProjectSurveyScrollView alloc] initWithFrame:collectionView.frame];
        }
        cell.project = self.projectInfoDetail;
        return cell;
        
    } else {
        PGCProjectContactScrollView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProjectContactScrollView forIndexPath:indexPath];
        if (!cell) {
            cell = [[PGCProjectContactScrollView alloc] initWithFrame:collectionView.frame];
        }
        cell.contactDataSource = self.contactData;
        return cell;
    }
}


#pragma mark - Setter

- (void)setProjectInfoDetail:(PGCProjectInfo *)projectInfoDetail
{
    _projectInfoDetail = projectInfoDetail;
    
    NSString *collectBtnTitle = projectInfoDetail.collect_id > 0 ? @"取消收藏" : @"收藏此项目";
    [self.navButton setTitle:collectBtnTitle forState:UIControlStateNormal];
    
    CGFloat labelInset = [_navButton.titleLabel intrinsicContentSize].width - _navButton.imageView.width_sd - _navButton.width_sd;
    CGFloat imageInset = _navButton.imageView.width_sd - _navButton.width_sd - _navButton.titleLabel.width_sd;
    _navButton.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    _navButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navButton];
}


#pragma mark - Getter

- (NSMutableArray *)segmentBtns {
    if (!_segmentBtns) {
        _segmentBtns = [NSMutableArray array];
    }
    return _segmentBtns;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, self.view.height_sd - self.projectTitleView.bottom - 1);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.projectTitleView.bottom, self.view.width_sd, self.view.height_sd - self.projectTitleView.bottom) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = false;
        _collectionView.pagingEnabled = true;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PGCProjectSurveyScrollView class] forCellWithReuseIdentifier:kProjectSurveyScrollView];
        [_collectionView registerClass:[PGCProjectContactScrollView class] forCellWithReuseIdentifier:kProjectContactScrollView];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIButton *)navButton {
    if (!_navButton) {
        // 导航栏收藏按钮
        _navButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _navButton.bounds = CGRectMake(0, 0, 90, 40);
        [_navButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        [_navButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_navButton setTitleColor:PGCTextColor forState:UIControlStateNormal];
        [_navButton setTintColor:PGCTextColor];
        [_navButton addTarget:self action:@selector(respondsToCollect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navButton;
}



@end
