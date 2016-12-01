//
//  PGCIntroduceSelectView.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIntroduceSelectView.h"

@interface PGCIntroduceSelectView ()

@property (strong, nonatomic) UILabel *titleLabel;/** 标题标签 */

@end

@implementation PGCIntroduceSelectView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content
{
    self = [super init];
    if (self) {
        
        [self createUITitle:title content:content];
    }
    return self;
}

- (void)createUITitle:(NSString *)title content:(NSString *)content
{
    self.backgroundColor = [UIColor whiteColor];
    // 标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = title;
    self.titleLabel.textColor = RGB(51, 51, 51);
    self.titleLabel.font = SetFont(15);
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 15)
    .widthIs([title sizeWithFont:SetFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 选择按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.selectBtn setTitle:content forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = SetFont(14);
    [self addSubview:self.selectBtn];
    self.selectBtn.sd_layout
    .centerYEqualToView(self.titleLabel)
    .leftSpaceToView(self.titleLabel, 10)
    .rightSpaceToView(self, 15)
    .heightIs(30);
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.selectBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
