//
//  PGCAddContactTableCell.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAddContactTableCell.h"

@implementation PGCAddContactRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextView *textView = [[UITextView alloc] init];
        textView.textColor = RGB(102, 102, 102);
        textView.font = SetFont(15);        
        textView.returnKeyType = UIReturnKeyDefault;
        textView.enablesReturnKeyAutomatically = true;
        textView.delegate = self;
        [self.contentView addSubview:textView];
        self.addRemarkTextView = textView;
        textView.sd_layout
        .topSpaceToView(self, 8)
        .leftSpaceToView(self, 15)
        .rightSpaceToView(self, 15)
        .bottomSpaceToView(self, 0);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = RGB(153, 153, 153);
        label.text = @"请输入备注";
        label.font = SetFont(15);
        [textView addSubview:label];
        self.textViewPlaceholder = label;
        label.sd_layout
        .topSpaceToView(textView, 2)
        .leftSpaceToView(textView, 15)
        .rightSpaceToView(textView, 15)
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
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.width, CGFLOAT_MAX)];
    if (size.height > 100) {
        textView.height = size.height;
    }
}

@end



@implementation PGCAddContactTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGB(51, 51, 51);
    titleLabel.font = SetFont(15);
    [self.contentView addSubview:titleLabel];
    self.addContactTitle = titleLabel;
    titleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(60)
    .heightIs(30);
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = RGB(102, 102, 102);
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = SetFont(15);
    textField.returnKeyType = UIReturnKeyDefault;
    textField.enablesReturnKeyAutomatically = true;
    [self.contentView addSubview:textField];
    self.addContactTF = textField;
    textField.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(titleLabel, 10)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(30);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
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
