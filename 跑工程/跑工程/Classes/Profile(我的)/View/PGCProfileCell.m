//
//  PGCProfileCell.m
//  跑工程
//
//  Created by leco on 2016/11/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProfileCell.h"

@interface PGCProfileCell ()

@property (weak, nonatomic) UIImageView *titleImage;/** 标题图片 */
@property (weak, nonatomic) UILabel *titleLabel;/** 标题 */
@property (weak, nonatomic) UIImageView *leftImage;/** 指示器图片 */
@property (weak, nonatomic) UILabel *detailLabel;/** 详情标题 */
@property (weak, nonatomic) UIButton *clickBtn;/** 点击事件按钮 */

@end

@implementation PGCProfileCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    UIImageView *titleImage = [[UIImageView alloc] init];
    [self addSubview:titleImage];
    titleImage.sd_layout
    .leftSpaceToView(self, 15)
    .centerYIs(self.bounds.size.height / 2)
    .heightIs(20)
    .widthIs(20);
    self.titleImage = titleImage;
    
    
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = [UIImage imageNamed:@"right"];
    [self addSubview:leftImage];
    leftImage.sd_layout
    .rightSpaceToView(self, 15)
    .centerYIs(self.bounds.size.height / 2)
    .heightIs(10)
    .widthIs(5);
    self.leftImage = leftImage;
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = RGB(128, 128, 128);
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.font = [UIFont boldSystemFontOfSize:10];
    [self addSubview:detailLabel];
    detailLabel.sd_layout
    .rightSpaceToView(leftImage, 10)
    .centerYEqualToView(titleImage)
    .leftSpaceToView(titleImage, 20)
    .autoHeightRatio(0);
    self.detailLabel = detailLabel;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(titleImage, 20)
    .centerYEqualToView(titleImage)
    .rightSpaceToView(leftImage, 20)
    .autoHeightRatio(0);
    self.titleLabel = titleLabel;
    
    
    UIButton *clickBtn = [[UIButton alloc] init];
    clickBtn.frame = self.bounds;
    clickBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:clickBtn];
    self.clickBtn = clickBtn;
}


- (void)addTarget:(id)target event:(SEL)event
{
    [self.clickBtn addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setter

- (void)setTitleImageName:(NSString *)titleImageName
{
    _titleImageName = titleImageName;
    
    self.titleImage.image = [UIImage imageNamed:titleImageName];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setDetailTitle:(NSString *)detailTitle
{
    _detailTitle = detailTitle;
    
    self.detailLabel.text = detailTitle;
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    
    self.detailLabel.hidden = !isShow;
}

@end
