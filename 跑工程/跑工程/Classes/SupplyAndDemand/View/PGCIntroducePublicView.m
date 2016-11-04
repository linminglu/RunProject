//
//  PGCIntroducePublicView.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIntroducePublicView.h"

@interface PGCIntroducePublicView ()
/**
 标题标签
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 内容文本输入框
 */
@property (strong, nonatomic) UITextField *contentTF;

@end

@implementation PGCIntroducePublicView

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
    
    // 内容输入框
    self.contentTF = [[UITextField alloc] init];
    self.contentTF.textAlignment = NSTextAlignmentLeft;
    self.contentTF.borderStyle = UITextBorderStyleNone;
    self.contentTF.placeholder = @"请输入文字";
    self.contentTF.textColor = RGB(102, 102, 102);
    self.contentTF.font = SetFont(14);
    [self addSubview:self.contentTF];
    self.contentTF.sd_layout
    .centerYEqualToView(self.titleLabel)
    .leftSpaceToView(self.titleLabel, 10)
    .rightSpaceToView(self, 15)
    .heightIs(30);
}

@end
