//
//  PGCAddContactRemarkCell.m
//  跑工程
//
//  Created by leco on 2016/11/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAddContactRemarkCell.h"

@interface PGCAddContactRemarkCell ()

@property (strong, nonatomic) UILabel *textViewPlaceholder;/** 文本视图占位符 */

@end

@implementation PGCAddContactRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.addRemarkTextView = [[UITextView alloc] init];
        self.addRemarkTextView.textColor = RGB(102, 102, 102);
        self.addRemarkTextView.font = SetFont(15);
        self.addRemarkTextView.returnKeyType = UIReturnKeyDefault;
        self.addRemarkTextView.enablesReturnKeyAutomatically = true;
        self.addRemarkTextView.delegate = self;
        self.addRemarkTextView.layer.cornerRadius = 5.0;
        self.addRemarkTextView.layer.borderColor = PGCBackColor.CGColor;
        self.addRemarkTextView.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.addRemarkTextView];
        self.addRemarkTextView.sd_layout
        .topSpaceToView(self.contentView, 5)
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .bottomSpaceToView(self.contentView, 20);
        
        self.textViewPlaceholder = [[UILabel alloc] init];
        self.textViewPlaceholder.textColor = RGB(153, 153, 153);
        self.textViewPlaceholder.text = @"请输入备注";
        self.textViewPlaceholder.font = SetFont(15);
        [self.addRemarkTextView addSubview:self.textViewPlaceholder];
        self.textViewPlaceholder.sd_layout
        .topSpaceToView(self.addRemarkTextView, 2)
        .leftSpaceToView(self.addRemarkTextView, 5)
        .rightSpaceToView(self.addRemarkTextView, 5)
        .heightIs(30);
    }
    return self;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.textViewPlaceholder.hidden = true;
    } else {
        self.textViewPlaceholder.hidden = false;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(addContactRemarkCell:textView:)]) {
        [self.delegate addContactRemarkCell:self textView:textView];
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
