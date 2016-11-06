//
//  PGCIntroduceAddContactCell.m
//  跑工程
//
//  Created by leco on 2016/11/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIntroduceAddContactCell.h"

@interface PGCIntroduceAddContactCell ()
/**
 姓名输入框
 */
@property (strong, nonatomic) UITextField *nameTextField;
/**
 电话输入框
 */
@property (strong, nonatomic) UITextField *phoneTextField;
/**
 右上角删除按钮
 */
@property (strong, nonatomic) UIButton *deleteBtn;

@end

@implementation PGCIntroduceAddContactCell

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
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.backgroundColor = [UIColor clearColor];
    [self.deleteBtn setImage:image forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    self.deleteBtn.sd_layout
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(image.size.height)
    .widthIs(image.size.width);
    
    
    UIView *lineCenter = [[UIView alloc] init];
    lineCenter.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:lineCenter];
    lineCenter.sd_layout
    .centerYEqualToView(self.contentView)
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
    .bottomSpaceToView(lineCenter, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs([name.text sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 姓名内容标签
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.placeholder = @"请输入姓名";
    self.nameTextField.textColor = RGB(102, 102, 102);
    self.nameTextField.font = SetFont(14);
    [self.contentView addSubview:self.nameTextField];
    self.nameTextField.sd_layout
    .centerYEqualToView(name)
    .leftSpaceToView(name, 10)
    .rightSpaceToView(self.deleteBtn, 20)
    .heightIs(30);
    
    // 电话标签
    UILabel *phone = [[UILabel alloc] init];
    phone.text = @"电话：";
    phone.textColor = RGB(51, 51, 51);
    phone.font = SetFont(14);
    [self.contentView addSubview:phone];
    phone.sd_layout
    .topSpaceToView(lineCenter, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs([phone.text sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 电话内容标签
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.placeholder = @"请输入电话";
    self.phoneTextField.textColor = RGB(102, 102, 102);
    self.phoneTextField.font = SetFont(14);
    [self.contentView addSubview:self.phoneTextField];
    self.phoneTextField.sd_layout
    .centerYEqualToView(phone)
    .leftSpaceToView(phone, 10)
    .widthRatioToView(self.nameTextField, 1.0)
    .heightIs(30);
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = RGB(210, 210, 210);
    [self.contentView addSubview:bottomLine];
    bottomLine.sd_layout
    .bottomSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
}


#pragma mark - Event

- (void)addContactTarget:(id)target action:(SEL)action {
    [self.deleteBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
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
