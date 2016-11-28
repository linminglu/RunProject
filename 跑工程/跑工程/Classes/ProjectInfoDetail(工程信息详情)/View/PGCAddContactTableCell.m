//
//  PGCAddContactTableCell.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAddContactTableCell.h"

@interface PGCAddContactTableCell () <UITextFieldDelegate>


@end

@implementation PGCAddContactTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.addContactTitle = [[UILabel alloc] init];
    self.addContactTitle.textColor = RGB(51, 51, 51);
    self.addContactTitle.font = SetFont(15);
    [self.contentView addSubview:self.addContactTitle];
    
    self.addContactTitle.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(60)
    .heightIs(30);
    
    self.addContactTF = [[UITextField alloc] init];
    self.addContactTF.textColor = RGB(102, 102, 102);
    self.addContactTF.borderStyle = UITextBorderStyleNone;
    self.addContactTF.font = SetFont(15);
    self.addContactTF.returnKeyType = UIReturnKeyDefault;
    self.addContactTF.enablesReturnKeyAutomatically = true;
    self.addContactTF.delegate = self;
    [self.contentView addSubview:self.addContactTF];
    
    self.addContactTF.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.addContactTitle, 0)
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


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addContactTableCell:textField:)]) {
        [self.delegate addContactTableCell:self textField:textField];
    }
    return true;
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
