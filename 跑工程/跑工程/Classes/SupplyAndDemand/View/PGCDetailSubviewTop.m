//
//  PGCDetailSubview1.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDetailSubviewTop.h"
#import "PGCDetailTitleView.h"

@interface PGCDetailSubviewTop ()

@property (copy, nonatomic) NSArray *titleArr;
@property (copy, nonatomic) NSArray *contentArr;

@end

@implementation PGCDetailSubviewTop

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubviewsWithModel:model];
    }
    return self;
}

- (void)setupSubviewsWithModel:(id)model
{
    if (model == nil) {
        return;
    }
    self.titleArr = model[@"title"];
    self.contentArr = model[@"content"];
    
    PGCDetailTitleView *title = [[PGCDetailTitleView alloc] initWithTitle:self.titleArr[0] content:self.contentArr[0]];
    [self addSubview:title];
    title.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 灰色分割视图
    UIView *grayView_1 = [[UIView alloc] init];
    grayView_1.backgroundColor = RGB(244, 244, 244);
    [self addSubview:grayView_1];
    grayView_1.sd_layout
    .topSpaceToView(title, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(10);
    
    
    PGCDetailTitleView *time = [[PGCDetailTitleView alloc] initWithTitle:self.titleArr[1] content:self.contentArr[1]];
    [self addSubview:time];
    time.sd_layout
    .topSpaceToView(grayView_1, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 时间下面的分割线
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line_1];
    line_1.sd_layout
    .topSpaceToView(time, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    
    PGCDetailTitleView *unit = [[PGCDetailTitleView alloc] initWithTitle:self.titleArr[2] content:self.contentArr[2]];
    [self addSubview:unit];
    unit.sd_layout
    .topSpaceToView(line_1, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 采购单位下面的分割线
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line_2];
    line_2.sd_layout
    .topSpaceToView(unit, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    
    PGCDetailTitleView *address = [[PGCDetailTitleView alloc] initWithTitle:self.titleArr[3] content:self.contentArr[3]];
    [self addSubview:address];
    address.sd_layout
    .topSpaceToView(line_2, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 灰色分割视图
    UIView *grayView_2 = [[UIView alloc] init];
    grayView_2.backgroundColor = RGB(244, 244, 244);
    [self addSubview:grayView_2];
    grayView_2.sd_layout
    .topSpaceToView(address, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(10);
    
    
    PGCDetailTitleView *area = [[PGCDetailTitleView alloc] initWithTitle:self.titleArr[4] content:self.contentArr[4]];
    [self addSubview:area];
    area.sd_layout
    .topSpaceToView(grayView_2, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);

    // 地区下面的分割线
    UIView *line_3 = [[UIView alloc] init];
    line_3.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line_3];
    line_3.sd_layout
    .topSpaceToView(area, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    
    PGCDetailTitleView *demand = [[PGCDetailTitleView alloc] initWithTitle:self.titleArr[5] content:self.contentArr[5]];
    [self addSubview:demand];
    demand.sd_layout
    .topSpaceToView(line_3, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    [self setupAutoHeightWithBottomView:demand bottomMargin:0];
}

@end
