//
//  IntroduceDemandDescCell.m
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "IntroduceDemandDescCell.h"

@interface IntroduceDemandDescCell () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *descTextView;/** 详细介绍输入框 */
@property (strong, nonatomic) UILabel *placeholder;/** 输入框提示语 */

@end

@implementation IntroduceDemandDescCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.descTextView = [[UITextView alloc] init];
    self.descTextView.textColor = RGB(51, 51, 51);
    self.descTextView.font = SetFont(14);
    self.descTextView.delegate = self;
    self.descTextView.layer.cornerRadius = 5.0;
    self.descTextView.layer.borderColor = PGCBackColor.CGColor;
    self.descTextView.layer.borderWidth = 0.5;
    [self.contentView addSubview:self.descTextView];
    self.descTextView.sd_layout
    .topSpaceToView(self.contentView, 5)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(100);
    
    self.placeholder = [[UILabel alloc] init];
    self.placeholder.font = SetFont(14);
    self.placeholder.textColor = RGB(212, 212, 212);
    [self.descTextView addSubview:self.placeholder];
    self.placeholder.sd_layout
    .topSpaceToView(self.descTextView, 8)
    .leftSpaceToView(self.descTextView, 8)
    .rightSpaceToView(self.descTextView, 8)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.descTextView bottomMargin:5];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholder.text = @"详细介绍...";
    } else {
        self.placeholder.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.introduceDescs = textView.text;
    }
}


#pragma mark - Setter

- (void)setIntroduceDescs:(NSString *)introduceDescs
{
    _introduceDescs = introduceDescs;
    
    if (introduceDescs.length > 0) {
        self.descTextView.text = introduceDescs;
    } else {
        self.placeholder.text = @"详细介绍...";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
