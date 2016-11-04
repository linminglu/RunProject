//
//  PGCIntroduceDetailTopView.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIntroduceDetailTopView.h"
#import "PGCIntroducePublicView.h"
#import "PGCIntroduceSelectView.h"

@implementation PGCIntroduceDetailTopView

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
    PGCIntroducePublicView *title = [[PGCIntroducePublicView alloc] initWithTitle:@"标题：" content:@""];
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
    
    
    PGCIntroducePublicView *time = [[PGCIntroducePublicView alloc] initWithTitle:@"时间：" content:@""];
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
    
    
    PGCIntroducePublicView *unit = [[PGCIntroducePublicView alloc] initWithTitle:@"采购单位（个人）：" content:@""];
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
    
    
    PGCIntroducePublicView *address = [[PGCIntroducePublicView alloc] initWithTitle:@"地址：" content:@""];
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
    
    
    PGCIntroduceSelectView *area = [[PGCIntroduceSelectView alloc] initWithTitle:@"地区：" content:@"当前位置"];
    [area addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
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
    
    
    PGCIntroduceSelectView *demand = [[PGCIntroduceSelectView alloc] initWithTitle:@"需求：" content:@"点击选择"];
    [demand addTarget:self action:@selector(selectDemand:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:demand];
    demand.sd_layout
    .topSpaceToView(line_3, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    [self setupAutoHeightWithBottomView:demand bottomMargin:0];
}


#pragma mark - Event

- (void)selectArea:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDetailTopView:selectArea:)]) {
        [self.delegate introduceDetailTopView:self selectArea:sender];
    }
}

- (void)selectDemand:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDetailTopView:slectDemand:)]) {
        [self.delegate introduceDetailTopView:self slectDemand:sender];
    }
}

@end
