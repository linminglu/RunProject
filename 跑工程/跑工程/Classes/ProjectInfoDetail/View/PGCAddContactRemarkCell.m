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
        
        UITextView *textView = [[UITextView alloc] init];
        textView.textColor = RGB(102, 102, 102);
        textView.font = SetFont(15);
        textView.returnKeyType = UIReturnKeyDefault;
        textView.enablesReturnKeyAutomatically = true;
        textView.delegate = self;
        [self.contentView addSubview:textView];
        self.addRemarkTextView = textView;
        textView.sd_layout
        .topSpaceToView(self.contentView, 5)
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 0);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = RGB(153, 153, 153);
        label.text = @"请输入备注";
        label.font = SetFont(15);
        [textView addSubview:label];
        self.textViewPlaceholder = label;
        label.sd_layout
        .topSpaceToView(textView, 2)
        .leftSpaceToView(textView, 5)
        .rightSpaceToView(textView, 5)
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
