//
//  PGCIntroduceSelectView.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIntroduceSelectView.h"

@interface PGCIntroduceSelectView ()
/**
 标题标签
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 选择按钮
 */
@property (strong, nonatomic) UIButton *button;

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
    self.titleLabel.textColor = RGB(102, 102, 102);
    self.titleLabel.font = SetFont(15);
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 15)
    .widthIs([title sizeWithFont:SetFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 选择按钮
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.button setTitle:content forState:UIControlStateNormal];
    [self.button setTitleColor:RGB(182, 182, 182) forState:UIControlStateNormal];
    self.button.titleLabel.font = SetFont(14);
    [self addSubview:self.button];
    self.button.sd_layout
    .centerYEqualToView(self.titleLabel)
    .leftSpaceToView(self.titleLabel, 10)
    .rightSpaceToView(self, 15)
    .heightIs(30);
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

@end
