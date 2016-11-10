//
//  PGCProjectInfoDetailViewController.m
//  跑工程
//
//  Created by leco on 2016/10/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoDetailViewController.h"
#import "PGCProjectSurveyScrollView.h"
#import "PGCProjectContactScrollView.h"
#import "PGCMapViewController.h"

#define SegmentBtnTag 100

@interface PGCProjectInfoDetailViewController () <UICollectionViewDataSource>

/**
 集合视图
 */
@property (strong, nonatomic) UICollectionView *collectionView;
/**
 当前选中按钮
 */
@property (strong, nonatomic) UIButton *previousBtn;
/**
 存放按钮的数组
 */
@property (strong, nonatomic) NSMutableArray *segmentBtns;
/**
 项目名称背景视图
 */
@property (strong, nonatomic) UIView *projectTitleView;
/**
 初始化用户界面
 */
- (void)initializeUserInterface;

@end

@implementation PGCProjectInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    self.view.backgroundColor = RGB(244, 244, 244);
    self.navigationItem.title = @"项目详情";
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self collectBarItem]];
    
    CGFloat buttonWidth = (SCREEN_WIDTH - 2) / 3;
    NSArray *btnTitles = @[@"项目概况", @"联系人", @"地图模式"];
    
    for (int i = 0; i < btnTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * (buttonWidth + 1), 64, buttonWidth, 40);
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
    // 开始自动布局
    projectTitleView.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT + 41)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(50);
    
    // 项目名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = SetFont(16);
    nameLabel.text = self.projectInfoDetail.name;
    [projectTitleView addSubview:nameLabel];
    // 开始自动布局
    nameLabel.sd_layout
    .centerYEqualToView(projectTitleView)
    .leftSpaceToView(projectTitleView, 15)
    .rightSpaceToView(projectTitleView, 15)
    .autoHeightRatio(0);
}


#pragma mark - Events

- (void)respondsToSegmentButton:(UIButton *)sender {
    [self updateSegmentButton:sender isSelected:true];
}

- (void)updateSegmentButton:(UIButton *)button isSelected:(BOOL)selected {
    if ((self.previousBtn != nil) && (self.previousBtn != button)) {
        [self.previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [button setTitleColor:RGB(250, 117, 10) forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        self.previousBtn = button;
        NSInteger index = (button.tag - SegmentBtnTag);
        if (selected && index < 2) {
            self.collectionView.contentOffset = CGPointMake(index * self.collectionView.width, 0);
        } else {
            [self.navigationController pushViewController:[PGCMapViewController new] animated:true];
        }
    }];
}

/**
 收藏此项目按钮的点击事件

 @param sender
 */
- (void)respondsToCollect:(UIButton *)sender {
    static BOOL select = false;
    select = !select;
    [sender setTitle:select ? @"取消收藏":@"收藏此项目" forState:UIControlStateNormal];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        PGCProjectSurveyScrollView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProjectSurveyScrollView forIndexPath:indexPath];
        [cell setSurveyInfoWithModel:self.projectInfoDetail];
        return cell;
        
    } else {
        PGCProjectContactScrollView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProjectContactScrollView forIndexPath:indexPath];
        [cell setContactInfoWithModel:self.projectInfoDetail];
        return cell;
    }
}


#pragma mark - Getter

- (NSMutableArray *)segmentBtns {
    if (!_segmentBtns) {
        _segmentBtns = [@[] mutableCopy];
    }
    return _segmentBtns;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat y = self.projectTitleView.bottom;
        CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - y);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = size;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, size.width, size.height) collectionViewLayout:flowLayout];
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



#pragma mark - Other

- (UIButton *)collectBarItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 90, 40);
    [button setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:@"收藏此项目" forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelInset = [button.titleLabel intrinsicContentSize].width - button.imageView.width - button.width;
    CGFloat imageInset = button.imageView.width - button.width - button.titleLabel.width;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    return button;
}


@end
