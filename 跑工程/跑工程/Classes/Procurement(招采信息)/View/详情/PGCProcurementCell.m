//
//  PGCSupplyAndDemandCell.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProcurementCell.h"
#import "PGCDemand.h"

@interface PGCProcurementCell ()

@property (strong, nonatomic) UILabel *nameLabel;/** 标题 */
@property (strong, nonatomic) UILabel *contentLabel;/** 内容 */
@property (strong, nonatomic) UILabel *areaLabel;/** 地区 */
@property (strong, nonatomic) UILabel *categoryLabel;/** 项目类别 */
@property (strong, nonatomic) UILabel *timeLabel;/** 时间 */
@property (strong, nonatomic) UIView *line;/** 底部分割线 */

@end

@implementation PGCProcurementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
        [self setupSubviewsAutoLayout];
    }
    return self;
}

- (void)createUI
{
    // 标题
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = RGB(76, 141, 174);
    [self.contentView addSubview:self.nameLabel];
    
    // 内容
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = RGB(102, 102, 102);
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    // 地区
    self.areaLabel = [[UILabel alloc] init];
    self.areaLabel.font = [UIFont systemFontOfSize:11];
    self.areaLabel.textColor = RGB(187, 187, 187);
    [self.contentView addSubview:self.areaLabel];
    
    // 项目类别
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.font = [UIFont systemFontOfSize:11];
    self.categoryLabel.textColor = RGB(187, 187, 187);
    [self.contentView addSubview:self.categoryLabel];
    
    // 时间标签
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:9];
    self.timeLabel.textColor = RGB(187, 187, 187);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
}

#pragma mark - 在这里用三方自动布局进行约束

- (void)setupSubviewsAutoLayout
{
    // 标题
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    // 内容
    self.contentLabel.sd_layout
    .topSpaceToView(self.nameLabel, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0)
    .maxHeightIs(60);
    
    // 地区
    self.areaLabel.sd_layout
    .topSpaceToView(self.contentLabel, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(80)
    .heightIs(20);
    
    // 项目类别
    self.categoryLabel.sd_layout
    .centerYEqualToView(self.areaLabel)
    .leftSpaceToView(self.areaLabel, 0)
    .widthIs(80)
    .heightIs(20);
    
    CGFloat width = [@"yyyy年MM月dd日" sizeWithFont:SetFont(9) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width;
    // 时间标签
    self.timeLabel.sd_layout
    .bottomEqualToView(self.areaLabel)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(width)
    .heightIs(20);
    
    // 底部分割线
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:self.line];
    self.line.sd_layout
    .topSpaceToView(self.categoryLabel, 5)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
}


#pragma mark - Setter

- (void)setDemand:(PGCDemand *)demand
{
    _demand = demand;
    
    self.nameLabel.text = demand.title;
    self.contentLabel.text = demand.desc;
    self.areaLabel.text = demand.address;
    self.categoryLabel.text = demand.type_name;
    self.areaLabel.text = demand.city;
    self.timeLabel.text = [NSString dateString:demand.update_time];
    
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
