//
//  PGCContactsCell.m
//  跑工程
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactsCell.h"
#import "PGCContact.h"

@interface PGCContactsCell ()

@property (strong, nonatomic) UILabel *nameLabel;/** 联系人姓名 */
@property (strong, nonatomic) UILabel *projectLabel;/** 项目名 */
@property (strong, nonatomic) UIView *line;/** 分割线 */

@end

@implementation PGCContactsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self creatUI];
        [self setAutoLayout];
    }
    return self;
}

- (void)creatUI
{
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
    
    // 联系人姓名
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = PGCTextColor;
    self.nameLabel.font = SetFont(15);
    [self.contentView addSubview:self.nameLabel];
    
    // 项目名
    self.projectLabel = [[UILabel alloc] init];
    self.projectLabel.textColor = RGB(102, 102, 102);
    self.projectLabel.font = SetFont(12);
    [self.contentView addSubview:self.projectLabel];
}

- (void)setAutoLayout
{
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthRatioToView(self.contentView, 0.5)
    .autoHeightRatio(0);
    
    self.projectLabel.sd_layout
    .topSpaceToView(self.nameLabel, 20)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 30)
    .autoHeightRatio(0);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(239, 239, 241);
    [self.contentView addSubview:line];
    self.line = line;
    line.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.projectLabel, 15)
    .heightIs(1);
}


- (void)setContact:(PGCContact *)contact
{
    _contact = contact;    
    if (!contact) {
        return;
    }
    self.nameLabel.text = contact.name;
    self.projectLabel.text = contact.position;
    
    [self setupAutoHeightWithBottomView:self.line bottomMargin:0];
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
