//
//  PGCVIPServiceCell.m
//  跑工程
//
//  Created by leco on 2016/11/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCVIPServiceCell.h"

@interface PGCVIPServiceCell ()

@property (strong, nonatomic) UILabel *costLabel;/** 费用标签 */
@property (strong, nonatomic) UILabel *contentLabel;/** 服务说明标签 */

@end

@implementation PGCVIPServiceCell


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
    NSString *textStr = @"会员开通服务费用：¥";
    CGSize size = [textStr sizeWithFont:SetFont(16) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    // 会员开通服务费标签
    UILabel *label = [[UILabel alloc] init];
    label.textColor = PGCTextColor;
    label.font = SetFont(16);
    label.text = textStr;
    [self.contentView addSubview:label];
    label.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(size.width)
    .heightIs(40);
    
    self.costLabel = [[UILabel alloc] init];
    self.costLabel.textColor = PGCTextColor;
    self.costLabel.font = SetFont(16);
    self.costLabel.text = @"123.00";
    [self.contentView addSubview:self.costLabel];
    self.costLabel.sd_layout
    .centerYEqualToView(label)
    .leftSpaceToView(label, 0)
    .rightSpaceToView(self.contentView, 15)
    .heightRatioToView(label, 1.0);
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line];
    line.sd_layout
    .topSpaceToView(label, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    /* 服务说明标签 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = PGCTextColor;
    titleLabel.font = SetFont(15);
    titleLabel.text = @"服务说明：";
    [self.contentView addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(40);
    
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:centerView];
    centerView.sd_layout
    .topSpaceToView(titleLabel, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(70);

    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = RGB(102, 102, 102);
    self.contentLabel.font = SetFont(15);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"1、开通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务通会员服务";
    [centerView addSubview:self.contentLabel];
    self.contentLabel.sd_layout
    .topSpaceToView(centerView, 10)
    .leftSpaceToView(centerView, 15)
    .rightSpaceToView(centerView, 15)
    .autoHeightRatio(0);
    [centerView setupAutoHeightWithBottomView:self.contentLabel bottomMargin:5];
    
    // 立即支付按钮
    UIButton *payButton = [[UIButton alloc] init];
    payButton.backgroundColor = PGCTintColor;
    payButton.layer.masksToBounds = true;
    payButton.layer.cornerRadius = 10.0;
    [payButton.titleLabel setFont:SetFont(15)];
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(respondsToPayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:payButton];
    payButton.sd_layout
    .topSpaceToView(centerView, 10)
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(30);
    
    UIView *bottom = [[UIView alloc] init];
    bottom.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:bottom];
    bottom.sd_layout
    .bottomSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(1);
}


- (void)respondsToPayButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(vipServiceCell:payButton:)]) {
        [self.delegate vipServiceCell:self payButton:sender];
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
