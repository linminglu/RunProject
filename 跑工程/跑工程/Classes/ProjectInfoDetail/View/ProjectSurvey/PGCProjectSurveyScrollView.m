//
//  PGCProjectSurveyScrollView.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectSurveyScrollView.h"
#import "PGCProjectDetailTagView.h"
#import "NSString+Size.h"

@interface PGCProjectSurveyScrollView () <UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataSource;

- (void)initDataSource; /** 初始化数据源 */
- (void)initUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectSurveyScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDataSource];
        [self initUserInterface];
    }
    return self;
}

- (void)initDataSource {
    _dataSource = @[@"1、绿化设施相关的设备以及材料。", @"2、消防设施，安全防范电线电缆等设备材料", @"3、消防设施，安全防范电线电缆等设备材料", @"4、消防设施，安全防范电线电缆等设备材料"];
}

// 子控件布局
- (void)initUserInterface {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.showsVerticalScrollIndicator = false;
    [self.contentView addSubview:scrollView];
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    // 项目概况
    PGCProjectDetailTagView *surveyView = [[PGCProjectDetailTagView alloc] initWithFrame:CGRectZero title:@"项目概况"];
    [scrollView addSubview:surveyView];
    // 开始自动布局
    surveyView.sd_layout
    .topSpaceToView(scrollView, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    // 项目概况子视图
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:backView];
    // 开始自动布局
    backView.sd_layout
    .topSpaceToView(surveyView, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40 * 5);
    
    NSArray *contents = @[@"重庆市江北区", @"行政办公，文体娱乐", @"施工招标", @"2017年1月 至 2018年1月", @"重庆市江北区******"];
    NSArray *titles = @[@"工程地区：", @"项目类别：", @"项目阶段：", @"建筑周期：", @"项目地址："];
    for (int i = 0; i < titles.count; i++) {
        [self setLabelWithSuperView:backView index:i title:titles[i] content:contents[i]];
    }
    
    // 项目简介
    PGCProjectDetailTagView *introView = [[PGCProjectDetailTagView alloc] initWithFrame:CGRectZero title:@"项目简介"];
    [scrollView addSubview:introView];
    // 开始自动布局
    introView.sd_layout
    .topSpaceToView(backView, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    // 项目简介内容
    UILabel *introContentLabel = [[UILabel alloc] init];
    introContentLabel.text = @"项目的简单介绍，主要做什么的，什么类型的项目，现在是什么项目阶段";
    introContentLabel.textColor = RGB(51, 51, 51);
    introContentLabel.font = SetFont(14);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:introContentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [introContentLabel.text length])];
    [introContentLabel setAttributedText:attributedString];
    
    [scrollView addSubview:introContentLabel];
    // 开始自动布局
    introContentLabel.sd_layout
    .topSpaceToView(introView, 10)
    .leftSpaceToView(scrollView, 15)
    .rightSpaceToView(scrollView, 15)
    .autoHeightRatio(0);
    
    // 其他
    PGCProjectDetailTagView *otherView = [[PGCProjectDetailTagView alloc] initWithFrame:CGRectZero title:@"可能用到的设备，材料"];
    [scrollView addSubview:otherView];
    // 开始自动布局
    otherView.sd_layout
    .topSpaceToView(introContentLabel, 14)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    //可能用到的设置、材料视图
    UITableView *otherTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    otherTableView.rowHeight = 36;
    otherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    otherTableView.dataSource = self;
    [scrollView addSubview:otherTableView];
    otherTableView.sd_layout
    .topSpaceToView(otherView, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(36 * _dataSource.count);
    
    [scrollView setupAutoContentSizeWithBottomView:otherTableView bottomMargin:10];
}

- (void)setupOtherSubviews {
    
}

- (void)setLabelWithSuperView:(UIView *)superView index:(NSInteger)index title:(NSString *)title content:(NSString *)content {

    CGSize sizeA = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    CGSize sizeB = [content sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UILabel *labelA = [[UILabel alloc] init];
    labelA.font = SetFont(13);
    labelA.text = title;
    labelA.textColor = PGCTextColor;
    [superView addSubview:labelA];
    labelA.sd_layout
    .topSpaceToView(superView, index * 40)
    .leftSpaceToView(superView, 15)
    .widthIs(sizeA.width)
    .heightIs(34);
    
    UILabel *labelB = [[UILabel alloc] init];
    labelB.textColor = PGCTextColor;
    labelB.text = content;
    labelB.font = SetFont(14);
    [superView addSubview:labelB];
    
    labelB.sd_layout
    .centerYEqualToView(labelA)
    .leftSpaceToView(labelA, 10)
    .heightRatioToView(labelA, 1)
    .widthIs(sizeB.width);
    
    if (index == 4) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [superView addSubview:line];
        line.sd_layout
        .centerYEqualToView(labelA)
        .leftSpaceToView(labelB, 20)
        .heightRatioToView(labelB, 0.5)
        .widthIs(1);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:PGCThemeColor forState:UIControlStateNormal];
        [button setTitle:@"点击查看" forState:UIControlStateNormal];
        [button.titleLabel setFont:SetFont(11)];
        [button.layer setMasksToBounds:true];
        [button.layer setCornerRadius:8.0];
        [button.layer setBorderColor:PGCThemeColor.CGColor];
        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(respondsToCheckButton:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        button.sd_layout
        .centerYEqualToView(labelA)
        .leftSpaceToView(line, 10)
        .heightRatioToView(line, 1)
        .widthIs(60);
    }
}


#pragma mark - Events

- (void)respondsToCheckButton:(UIButton *)sender {
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SetFont(14);
    cell.textLabel.textColor = PGCTextColor;
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

@end
