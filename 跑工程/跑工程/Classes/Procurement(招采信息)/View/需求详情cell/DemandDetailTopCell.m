//
//  DemandDetailTopCell.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "DemandDetailTopCell.h"
#import "PGCDetailTitleView.h"
#import "PGCDemand.h"

@interface DemandDetailTopCell ()

@property (strong, nonatomic) PGCDetailTitleView *title;/** 标题 */
@property (strong, nonatomic) PGCDetailTitleView *startTime;/** 时间 */
@property (strong, nonatomic) PGCDetailTitleView *endTime;/** 时间 */
@property (strong, nonatomic) PGCDetailTitleView *unit;/** 采购单位 */
@property (strong, nonatomic) PGCDetailTitleView *address;/** 地址 */
@property (strong, nonatomic) PGCDetailTitleView *area;/** 地区 */
@property (strong, nonatomic) PGCDetailTitleView *demand;/** 需求 */

@end

@implementation DemandDetailTopCell


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
    self.title = [[PGCDetailTitleView alloc] initWithTitle:@"标题："];
    [self.contentView addSubview:self.title];
    self.title.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 灰色分割视图
    UIView *grayView_1 = [[UIView alloc] init];
    grayView_1.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:grayView_1];
    grayView_1.sd_layout
    .topSpaceToView(self.title, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(8);
    
    
    self.startTime = [[PGCDetailTitleView alloc] initWithTitle:@"时间："];
    [self.contentView addSubview:self.startTime];
    self.startTime.sd_layout
    .topSpaceToView(grayView_1, 0)
    .leftSpaceToView(self.contentView, 0)
    .widthRatioToView(self.contentView, 0.5)
    .heightIs(44);
    
    self.endTime = [[PGCDetailTitleView alloc] initWithTitle:@"至"];
    [self.contentView addSubview:self.endTime];
    self.endTime.sd_layout
    .centerYEqualToView(self.startTime)
    .leftSpaceToView(self.startTime, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    
    // 时间下面的分割线
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line_1];
    line_1.sd_layout
    .topSpaceToView(self.startTime, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    
    self.unit = [[PGCDetailTitleView alloc] initWithTitle:@"采购单位（个人）："];
    [self.contentView addSubview:self.unit];
    self.unit.sd_layout
    .topSpaceToView(line_1, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 采购单位下面的分割线
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line_2];
    line_2.sd_layout
    .topSpaceToView(self.unit, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    
    self.address = [[PGCDetailTitleView alloc] initWithTitle:@"地址："];
    [self.contentView addSubview:self.address];
    self.address.sd_layout
    .topSpaceToView(line_2, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 灰色分割视图
    UIView *grayView_2 = [[UIView alloc] init];
    grayView_2.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:grayView_2];
    grayView_2.sd_layout
    .topSpaceToView(self.address, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(8);
    
    
    self.area = [[PGCDetailTitleView alloc] initWithTitle:@"地区："];
    [self.contentView addSubview:self.area];
    self.area.sd_layout
    .topSpaceToView(grayView_2, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 地区下面的分割线
    UIView *line_3 = [[UIView alloc] init];
    line_3.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line_3];
    line_3.sd_layout
    .topSpaceToView(self.area, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    self.demand = [[PGCDetailTitleView alloc] initWithTitle:@"需求："];
    [self.contentView addSubview:self.demand];
    self.demand.sd_layout
    .topSpaceToView(line_3, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
}


#pragma mark - Setter

- (void)setTopDemand:(PGCDemand *)topDemand
{
    _topDemand = topDemand;
    
    self.title.content = topDemand.title;
    self.startTime.content = [topDemand.start_time substringToIndex:10];
    self.endTime.content = [topDemand.end_time substringToIndex:10];
    self.unit.content = topDemand.company;
    self.address.content = topDemand.address;
    self.area.content = [topDemand.province stringByAppendingString:topDemand.city];
    self.demand.content = topDemand.type_name;
    
    [self setupAutoHeightWithBottomView:self.demand bottomMargin:0];
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
