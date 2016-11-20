//
//  SupplyDetailTopCell.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "SupplyDetailTopCell.h"
#import "PGCDetailTitleView.h"
#import "PGCSupply.h"

@interface SupplyDetailTopCell ()

@property (strong, nonatomic) PGCDetailTitleView *title;/** 标题 */
@property (strong, nonatomic) PGCDetailTitleView *company;/** 供应商家 */
@property (strong, nonatomic) PGCDetailTitleView *address;/** 地址 */
@property (strong, nonatomic) PGCDetailTitleView *area;/** 地区 */
@property (strong, nonatomic) PGCDetailTitleView *type;/** 类别 */

@end

@implementation SupplyDetailTopCell

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
    
    
    self.company = [[PGCDetailTitleView alloc] initWithTitle:@"供应商家："];
    [self.contentView addSubview:self.company];
    self.company.sd_layout
    .topSpaceToView(grayView_1, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 供应商家下面的分割线
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line_1];
    line_1.sd_layout
    .topSpaceToView(self.company, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    
    self.address = [[PGCDetailTitleView alloc] initWithTitle:@"地址："];
    [self.contentView addSubview:self.address];
    self.address.sd_layout
    .topSpaceToView(line_1, 0)
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
    
    
    self.type = [[PGCDetailTitleView alloc] initWithTitle:@"类别："];
    [self.contentView addSubview:self.type];
    self.type.sd_layout
    .topSpaceToView(line_3, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
}


#pragma mark - Setter

- (void)setTopSupply:(PGCSupply *)topSupply
{
    _topSupply = topSupply;
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Types *type in topSupply.types) {
        [mutableArray addObject:type.name];
    }
    
    self.title.content = topSupply.title;
    self.company.content = topSupply.company;
    self.address.content = topSupply.address;
    self.area.content = [topSupply.province stringByAppendingString:topSupply.city];
    self.type.content = [mutableArray componentsJoinedByString:@","];
    
    [self setupAutoHeightWithBottomView:self.type bottomMargin:0];
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
