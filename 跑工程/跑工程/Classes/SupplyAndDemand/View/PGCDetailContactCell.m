//
//  PGCDetailContactCell.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDetailContactCell.h"

@interface PGCDetailContactCell ()

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *phoneLabel;

@end

@implementation PGCDetailContactCell


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
    UIImage *image = [UIImage imageNamed:@"phone-0"];
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.backgroundColor = [UIColor clearColor];
    [callBtn setImage:image forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(respondsToCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:callBtn];
    callBtn.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 30)
    .heightIs(image.size.height)
    .widthIs(image.size.width);
    
    UIView *lineH = [[UIView alloc] init];
    lineH.backgroundColor = PGCTintColor;
    [self.contentView addSubview:lineH];
    lineH.sd_layout
    .centerYEqualToView(callBtn)
    .rightSpaceToView(callBtn, 30)
    .heightRatioToView(callBtn, 1.5)
    .widthIs(1.5);
    
    
    UIView *lineCenter = [[UIView alloc] init];
    lineCenter.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:lineCenter];
    lineCenter.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(lineH, 20)
    .heightIs(1);
    
    // 姓名标签
    UILabel *name = [[UILabel alloc] init];
    name.text = @"姓名：";
    name.textColor = RGB(51, 51, 51);
    name.font = SetFont(15);
    [self.contentView addSubview:name];
    name.sd_layout
    .bottomSpaceToView(lineCenter, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs([name.text sizeWithFont:SetFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 姓名内容标签
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = RGB(102, 102, 102);
    self.nameLabel.font = SetFont(15);
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .centerYEqualToView(name)
    .leftSpaceToView(name, 10)
    .rightSpaceToView(lineH, 20)
    .autoHeightRatio(0);
    
    // 电话标签
    UILabel *phone = [[UILabel alloc] init];
    phone.text = @"电话：";
    phone.textColor = RGB(51, 51, 51);
    phone.font = SetFont(15);
    [self.contentView addSubview:phone];
    phone.sd_layout
    .topSpaceToView(lineCenter, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs([phone.text sizeWithFont:SetFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width)
    .autoHeightRatio(0);
    
    // 电话内容标签
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.textColor = RGB(102, 102, 102);
    self.phoneLabel.font = SetFont(15);
    [self.contentView addSubview:self.phoneLabel];
    self.phoneLabel.sd_layout
    .centerYEqualToView(phone)
    .leftSpaceToView(phone, 10)
    .rightSpaceToView(lineH, 20)
    .autoHeightRatio(0);
    
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

- (void)respondsToCallBtn:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(contactCell:callBtn:)]) {
        [self.delegate contactCell:self callBtn:sender];
    }
}


#pragma mark - Setter

- (void)setContactDic:(NSDictionary *)contactDic {
    _contactDic = contactDic;
    
    self.nameLabel.text = contactDic[@"name"];
    self.phoneLabel.text = contactDic[@"phone"];
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
