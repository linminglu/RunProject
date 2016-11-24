//
//  IntroduceDemandContactCell.m
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "IntroduceDemandContactCell.h"
#import "Contacts.h"

@interface IntroduceDemandContactCell () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nameTextField;/** 姓名输入框 */
@property (strong, nonatomic) UITextField *phoneTextField;/** 电话输入框 */
@property (strong, nonatomic) UIButton *deleteButton;/** 右上角删除按钮 */
@property (strong, nonatomic) UIView *lineCenter;/** 分割线 */

@end

@implementation IntroduceDemandContactCell


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
    UIImage *image = [UIImage imageNamed:@"删除"];
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.backgroundColor = [UIColor clearColor];
    [self.deleteButton setImage:image forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(respondsToDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    self.deleteButton.sd_layout
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(20)
    .widthIs(40);
    self.deleteButton.hidden = true;
    
    self.lineCenter = [[UIView alloc] init];
    self.lineCenter.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:self.lineCenter];
    self.lineCenter.sd_layout
    .topSpaceToView(self.contentView, 40)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(1);
    
    // 姓名标签
    UILabel *name = [[UILabel alloc] init];
    name.text = @"姓名：";
    name.textColor = RGB(51, 51, 51);
    name.font = SetFont(14);
    [self.contentView addSubview:name];
    name.sd_layout
    .bottomSpaceToView(self.lineCenter, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs([name.text sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 姓名内容标签
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.placeholder = @"请输入姓名";
    self.nameTextField.textColor = RGB(102, 102, 102);
    self.nameTextField.font = SetFont(14);
    self.nameTextField.delegate = self;
    [self.contentView addSubview:self.nameTextField];
    self.nameTextField.sd_layout
    .centerYEqualToView(name)
    .leftSpaceToView(name, 10)
    .rightSpaceToView(self.contentView, 40)
    .heightIs(30);
    
    // 电话标签
    UILabel *phone = [[UILabel alloc] init];
    phone.text = @"电话：";
    phone.textColor = RGB(51, 51, 51);
    phone.font = SetFont(14);
    [self.contentView addSubview:phone];
    phone.sd_layout
    .topSpaceToView(self.lineCenter, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs([phone.text sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 电话内容标签
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.placeholder = @"请输入电话";
    self.phoneTextField.textColor = RGB(102, 102, 102);
    self.phoneTextField.font = SetFont(14);
    self.phoneTextField.delegate = self;
    [self.contentView addSubview:self.phoneTextField];
    self.phoneTextField.sd_layout
    .centerYEqualToView(phone)
    .leftSpaceToView(phone, 10)
    .widthRatioToView(self.nameTextField, 1.0)
    .heightIs(30);
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:bottomLine];
    bottomLine.sd_layout
    .bottomSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:self.lineCenter bottomMargin:40];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!(textField.text.length > 0)) {
        return;
    }
    if (textField == self.nameTextField) {
        self.contact.name = textField.text;
    }
    if (textField == self.phoneTextField) {
        self.contact.phone = textField.text;
    }
}


#pragma mark - Event

- (void)respondsToDeleteBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceDemandContactCell:deleteBtn:)]) {
        [self.delegate introduceDemandContactCell:self deleteBtn:sender];
    }
}


#pragma mark - Setter

- (void)setContact:(Contacts *)contact
{
    _contact = contact;
    
    self.nameTextField.text = contact.name ? contact.name : @"";
    self.phoneTextField.text = contact.phone ? contact.phone : @"";
}

- (void)setButtonHidden:(BOOL)hidden
{
    self.deleteButton.hidden = hidden;
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
