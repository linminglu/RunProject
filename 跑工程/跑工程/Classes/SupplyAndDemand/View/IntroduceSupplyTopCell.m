//
//  IntroduceSupplyTopCell.m
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "IntroduceSupplyTopCell.h"
#import "PGCIntroducePublicView.h"
#import "PGCIntroduceSelectView.h"
#import "PGCSupply.h"

@interface IntroduceSupplyTopCell ()

@property (strong, nonatomic) PGCIntroducePublicView *title;/** 标题 */
@property (strong, nonatomic) PGCIntroducePublicView *company;/** 供应商 */
@property (strong, nonatomic) PGCIntroducePublicView *address;/** 地址 */
@property (strong, nonatomic) PGCIntroduceSelectView *area;/** 地区 */
@property (strong, nonatomic) PGCIntroduceSelectView *type;/** 类别 */

@end

@implementation IntroduceSupplyTopCell


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
    self.title = [[PGCIntroducePublicView alloc] initWithTitle:@"标题：" placeholder:@"请输入标题"];
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
    
    
    self.company = [[PGCIntroducePublicView alloc] initWithTitle:@"供应商家：" placeholder:@"请输入供应商家"];
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
    
    
    self.address = [[PGCIntroducePublicView alloc] initWithTitle:@"地址：" placeholder:@"请输入地址"];
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
    
    
    self.area = [[PGCIntroduceSelectView alloc] initWithTitle:@"地区：" content:@"当前位置"];
    [self.area addTarget:self action:@selector(selectArea:)];
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
    
    
    self.type = [[PGCIntroduceSelectView alloc] initWithTitle:@"需求：" content:@"点击选择"];
    [self.type addTarget:self action:@selector(selectDemand:)];
    [self.contentView addSubview:self.type];
    self.type.sd_layout
    .topSpaceToView(line_3, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    [self setupAutoHeightWithBottomView:self.type bottomMargin:0];
}



#pragma mark - Setter

- (void)setTopSupply:(PGCSupply *)topSupply
{
    _topSupply = topSupply;
    
    if (!topSupply) {
        return;
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Types *type in topSupply.types) {
        [mutableArray addObject:type.name];
    }
    self.title.contentTF.text = topSupply.title;
    self.company.contentTF.text = topSupply.company;
    self.address.contentTF.text = topSupply.address;
    
    [self.area.selectBtn setTitle:[topSupply.province stringByAppendingString:topSupply.city] forState:UIControlStateNormal];
    [self.type.selectBtn setTitle:[mutableArray componentsJoinedByString:@","] forState:UIControlStateNormal];
}

#pragma mark - Event

- (void)selectArea:(UIButton *)sender
{
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceSupplyTopCell:selectArea:)]) {
        [self.delegate introduceSupplyTopCell:self selectArea:sender];
    }
}

- (void)selectDemand:(UIButton *)sender
{
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceSupplyTopCell:slectDemand:)]) {
        [self.delegate introduceSupplyTopCell:self slectDemand:sender];
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
