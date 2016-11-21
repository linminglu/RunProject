//
//  PGCDetailTitleView.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDetailTitleView.h"

@interface PGCDetailTitleView ()

@property (strong, nonatomic) UILabel *titleLabel;/** 标题标签 */
@property (strong, nonatomic) UILabel *contentLabel;/** 内容标签 */

@end

@implementation PGCDetailTitleView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        [self createUITitle:title];
    }
    return self;
}

- (void)createUITitle:(NSString *)title
{
    self.backgroundColor = [UIColor whiteColor];
    // 标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = title;
    self.titleLabel.textColor = RGB(51, 51, 51);
    self.titleLabel.font = SetFont(14);
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 15)
    .widthIs([title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 内容标签
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = RGB(102, 102, 102);
    self.contentLabel.font = SetFont(14);
    [self addSubview:self.contentLabel];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    self.contentLabel.text = content;
    
    self.contentLabel.sd_resetNewLayout
    .centerYEqualToView(self.titleLabel)
    .leftSpaceToView(self.titleLabel, 10)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
}

@end
