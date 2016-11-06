//
//  PGCAddContactTableCell.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAddContactTableCell.h"

@implementation PGCAddContactTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
