//
//  PGCProjectSurveyScrollView.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectSurveyScrollView.h"
#import "PGCProjectDetailTagView.h"
#import "PGCProjectSurveySubview.h"
#import "PGCProjectInfo.h"

@interface PGCProjectSurveyScrollView ()

@property (strong, nonatomic) PGCProjectSurveySubview *surveySubview;/** 项目概况 */
@property (strong, nonatomic) UILabel *introContentLabel;/** 项目简介 */
@property (strong, nonatomic) UILabel *materialLabel;/** 可能用到的材料 */

- (void)initUserInterface;/* 初始化用户界面 */

@end

@implementation PGCProjectSurveyScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}


#pragma mark - Init method

// 子控件布局
- (void)initUserInterface {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.showsVerticalScrollIndicator = false;
    [self.contentView addSubview:scrollView];
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    // 项目概况
    PGCProjectDetailTagView *surveyView = [[PGCProjectDetailTagView alloc] initWithTitle:@"项目概况"];
    [scrollView addSubview:surveyView];
    surveyView.sd_layout
    .topSpaceToView(scrollView, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    #pragma mark *** 项目概况子视图 ***
    PGCProjectSurveySubview *surveySubview = [[PGCProjectSurveySubview alloc] init];
    [scrollView addSubview:surveySubview];
    [surveySubview addBtnTarget:self action:@selector(respondsToCheckButton:)];
    self.surveySubview = surveySubview;
    surveySubview.sd_layout
    .topSpaceToView(surveyView, 10)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .autoHeightRatio(0);
    
    
    // 项目简介
    PGCProjectDetailTagView *introView = [[PGCProjectDetailTagView alloc] initWithTitle:@"项目简介"];
    [scrollView addSubview:introView];
    introView.sd_layout
    .topSpaceToView(surveySubview, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    #pragma mark *** 项目简介内容 ***
    UILabel *introContentLabel = [[UILabel alloc] init];
    introContentLabel.textColor = PGCTextColor;
    introContentLabel.font = SetFont(14);
    introContentLabel.numberOfLines = 0;
    [scrollView addSubview:introContentLabel];
    self.introContentLabel = introContentLabel;
    introContentLabel.sd_layout
    .topSpaceToView(introView, 10)
    .leftSpaceToView(scrollView, 15)
    .rightSpaceToView(scrollView, 15)
    .autoHeightRatio(0);
    
    // 其他
    PGCProjectDetailTagView *otherView = [[PGCProjectDetailTagView alloc] initWithTitle:@"可能用到的设备，材料"];
    [scrollView addSubview:otherView];
    otherView.sd_layout
    .topSpaceToView(introContentLabel, 30)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    #pragma mark *** 可能用到的设置、材料视图 ***
    UILabel *materialLabel = [[UILabel alloc] init];
    materialLabel.textColor = PGCTextColor;
    materialLabel.font = SetFont(14);
    materialLabel.numberOfLines = 0;
    [scrollView addSubview:materialLabel];
    self.materialLabel = materialLabel;
    materialLabel.sd_layout
    .topSpaceToView(otherView, 10)
    .leftSpaceToView(scrollView, 15)
    .rightSpaceToView(scrollView, 15)
    .autoHeightRatio(0);
    
    [scrollView setupAutoContentSizeWithBottomView:materialLabel bottomMargin:10];
}


#pragma mark - Events

- (void)respondsToCheckButton:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark - Public

- (void)setSurveyInfoWithModel:(id)model {
    if (!model) {
        return;
    }
    [self.surveySubview loadDataWithModel:model];
    
    PGCProjectInfo *project = (PGCProjectInfo *)model;
    
    self.introContentLabel.text = project.desc;
    
    self.materialLabel.text = project.material;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introContentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [self.introContentLabel.text length])];
    [self.introContentLabel setAttributedText:attributedString];
}


@end
