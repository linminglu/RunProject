//
//  DemandDetailDescCell.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "DemandDetailDescCell.h"
#import "PGCDemand.h"
#import "PGCSupply.h"

@interface DemandDetailDescCell ()

@property (strong, nonatomic) UILabel *introduceLabel;/** 详细介绍 */

@end

@implementation DemandDetailDescCell


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
    self.introduceLabel = [[UILabel alloc] init];
    self.introduceLabel.textColor = RGB(102, 102, 102);
    self.introduceLabel.font = SetFont(15);
    self.introduceLabel.numberOfLines = 0;
    [self.contentView addSubview:self.introduceLabel];
    self.introduceLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
}


#pragma mark - Setter

- (void)setDemandDesc:(PGCDemand *)demandDesc
{
    _demandDesc = demandDesc;
    
    self.introduceLabel.text = demandDesc.desc;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    
    self.introduceLabel.attributedText = [[NSAttributedString alloc] initWithString:demandDesc.desc attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    self.introduceLabel.isAttributedContent = true;
    
    [self setupAutoHeightWithBottomView:self.introduceLabel bottomMargin:10];
}

- (void)setSupplyDesc:(PGCSupply *)supplyDesc
{
    _supplyDesc = supplyDesc;
    
    self.introduceLabel.text = supplyDesc.desc;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    
    self.introduceLabel.attributedText = [[NSAttributedString alloc] initWithString:supplyDesc.desc attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    self.introduceLabel.isAttributedContent = true;
    
    [self setupAutoHeightWithBottomView:self.introduceLabel bottomMargin:10];
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
