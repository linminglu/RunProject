//
//  PGCContacInfoHeaderView.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContacInfoHeaderView.h"
#import "PGCContact.h"

@interface PGCContacInfoHeaderView ()

@property (strong, nonatomic) UIImageView *headImageView;/** 头像 */
@property (strong, nonatomic) UILabel *contactNameLabel;/** 姓名 */
@property (strong, nonatomic) UILabel *projectNameLabel;/** 项目名称 */
@property (strong, nonatomic) UIButton *contactInfoBtn;/** 个人资料按钮 */
@property (strong, nonatomic) UIButton *projectsBtn;/** 参与的项目按钮 */
@property (strong, nonatomic) UIView *lineBottom;/** 分割线 */

@end

@implementation PGCContacInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
        [self setAutoLayoutSubviews];
    }
    return self;
}

- (void)createUI
{
    // 头像
    self.headImageView = [[UIImageView alloc] init];
    [self addSubview:self.headImageView];
    
    // 姓名
    self.contactNameLabel = [[UILabel alloc] init];
    self.contactNameLabel.textColor = RGB(102, 102, 102);
    self.contactNameLabel.font = SetFont(14);
    self.contactNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.contactNameLabel];
    
    // 项目名称
    self.projectNameLabel = [[UILabel alloc] init];
    self.projectNameLabel.textColor = RGB(158, 158, 158);
    self.projectNameLabel.font = SetFont(12);
    self.projectNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.projectNameLabel];
    
    // 个人资料按钮
    self.contactInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contactInfoBtn.titleLabel setFont:SetFont(15)];
    [self.contactInfoBtn setTitle:@"个人资料" forState:UIControlStateNormal];
    [self.contactInfoBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [self.contactInfoBtn setTitleColor:PGCTintColor forState:UIControlStateSelected];
    [self.contactInfoBtn addTarget:self action:@selector(contactInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contactInfoBtn];
    self.contactInfoBtn.selected = true;
    self.contactInfoBtn.userInteractionEnabled = false;
    
    // 参与的项目按钮
    self.projectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.projectsBtn.titleLabel setFont:SetFont(15)];
    [self.projectsBtn setTitle:@"参与的项目" forState:UIControlStateNormal];
    [self.projectsBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [self.projectsBtn setTitleColor:PGCTintColor forState:UIControlStateSelected];
    [self.projectsBtn addTarget:self action:@selector(projectsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.projectsBtn];
    self.projectsBtn.selected = false;
    self.projectsBtn.userInteractionEnabled = true;
}


- (void)setAutoLayoutSubviews
{
    self.headImageView.sd_layout
    .centerXIs(SCREEN_WIDTH / 2)
    .topSpaceToView(self, 20)
    .widthIs(50)
    .heightIs(50);
    
    self.contactNameLabel.sd_layout
    .centerXEqualToView(self.headImageView)
    .topSpaceToView(self.headImageView, 10)
    .widthRatioToView(self, 0.5)
    .heightIs(20);
    
    self.projectNameLabel.sd_layout
    .centerXEqualToView(self.headImageView)
    .topSpaceToView(self.contactNameLabel, 10)
    .widthRatioToView(self, 0.5)
    .heightIs(20);
    
    
    UIView *lineTop = [[UIView alloc] init];
    lineTop.backgroundColor = PGCBackColor;
    [self addSubview:lineTop];
    lineTop.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self.projectNameLabel, 10)
    .heightIs(1);
    
    
    UIView *lineCenter = [[UIView alloc] init];
    lineCenter.backgroundColor = PGCBackColor;
    [self addSubview:lineCenter];
    lineCenter.sd_layout
    .centerXEqualToView(self.headImageView)
    .topSpaceToView(lineTop, 15)
    .heightIs(10)
    .widthIs(1);
    
    
    self.contactInfoBtn.sd_layout
    .centerYEqualToView(lineCenter)
    .rightSpaceToView(lineCenter, 30)
    .leftSpaceToView(self, 30)
    .heightIs(20);
    
    
    self.projectsBtn.sd_layout
    .centerYEqualToView(lineCenter)
    .leftSpaceToView(lineCenter, 30)
    .rightSpaceToView(self, 30)
    .heightIs(20);
    
    
    UIView *lineBottom = [[UIView alloc] init];
    lineBottom.backgroundColor = PGCBackColor;
    [self addSubview:lineBottom];
    self.lineBottom = lineBottom;
    lineBottom.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(lineCenter, 15)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:self.lineBottom bottomMargin:0];
}


- (void)setContactHeader:(PGCContact *)contactHeader
{
    _contactHeader = contactHeader;
    
    self.headImageView.image = [UIImage imageNamed:@"头像"];
    self.contactNameLabel.text = contactHeader.name;
    self.projectNameLabel.text = contactHeader.company;
}


#pragma mark - Event

- (void)contactInfoBtnClick:(UIButton *)sender
{
    self.contactInfoBtn.selected = true;
    self.contactInfoBtn.userInteractionEnabled = false;
    
    self.projectsBtn.selected = false;
    self.projectsBtn.userInteractionEnabled = true;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactInfoHeaderView:contactInfoBtn:)]) {
        [self.delegate contactInfoHeaderView:self contactInfoBtn:sender];
    }
}

- (void)projectsBtnClick:(UIButton *)sender
{
    self.projectsBtn.selected = true;
    self.projectsBtn.userInteractionEnabled = false;
    
    self.contactInfoBtn.selected = false;
    self.contactInfoBtn.userInteractionEnabled = true;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactInfoHeaderView:projectsBtn:)]) {
        [self.delegate contactInfoHeaderView:self projectsBtn:sender];
    }
}

@end
