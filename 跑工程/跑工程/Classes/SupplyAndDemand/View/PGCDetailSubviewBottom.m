//
//  PGCDetailSubview2.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDetailSubviewBottom.h"
#import "PGCProjectDetailTagView.h"
#import "PGCDetailContactCell.h"
#import "PGCDemand.h"
#import "PGCSupply.h"

@interface PGCDetailSubviewBottom () <UITableViewDataSource, UITableViewDelegate, PGCDetailContactCellDelegate>

@property (strong, nonatomic) UITableView *tableView;/** 联系人表格视图 */
@property (strong, nonatomic) UILabel *introduceLabel;/** 详细介绍 */
@property (strong, nonatomic) NSMutableArray *contactDatas;/** 联系人数组 */
@property (strong, nonatomic) NSMutableArray *imageDatas;/** 图片数组 */
@property (strong, nonatomic) NSMutableArray *fileDatas;/** 文件数组 */
@property (strong, nonatomic) UIView *checkMoreView;/** 查看更多联系人视图 */

@property (strong, nonatomic) PGCDemand *demand;
@property (strong, nonatomic) PGCSupply *supply;

@end

@implementation PGCDetailSubviewBottom

- (instancetype)initWithModel:(id)model;
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
    if ([model isKindOfClass:[PGCDemand class]]) {
        self.demand = (PGCDemand *)model;
        
        self.introduceLabel.text = self.demand.desc;
        [self.contactDatas addObjectsFromArray:self.demand.contacts];
        [self.imageDatas addObject:self.demand.images];
        [self.fileDatas addObject:self.demand.files];
    }
    if ([model isKindOfClass:[PGCSupply class]]) {
        self.supply = (PGCSupply *)model;
        
        self.introduceLabel.text = self.supply.desc;
        [self.contactDatas addObjectsFromArray:self.supply.contacts];
        [self.imageDatas addObject:self.supply.images];
        [self.fileDatas addObject:self.supply.files];
    }
    
    PGCProjectDetailTagView *contact = [[PGCProjectDetailTagView alloc] initWithTitle:@"联系人"];
    [self addSubview:contact];
    
    PGCProjectDetailTagView *introduce = [[PGCProjectDetailTagView alloc] initWithTitle:@"详细介绍"];
    [self addSubview:introduce];
    
    PGCProjectDetailTagView *imageIntroduce = [[PGCProjectDetailTagView alloc] initWithTitle:@"图片介绍"];
    [self addSubview:imageIntroduce];
    
    PGCProjectDetailTagView *fileDownload = [[PGCProjectDetailTagView alloc] initWithTitle:@"文件下载"];
    [self addSubview:fileDownload];
    
    // 联系人
    contact.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    if (self.contactDatas.count > 1) {
        // 联系人表格视图布局
        self.tableView.sd_layout
        .topSpaceToView(contact, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(80);
        
        // 查看更多联系人视图布局
        [self addSubview:self.checkMoreView];
        self.checkMoreView.sd_layout
        .topSpaceToView(self.tableView, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(40);
        
        // 详细介绍
        introduce.sd_layout
        .topSpaceToView(self.checkMoreView, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(40);
        
    } else {
        // 联系人表格视图布局
        self.tableView.sd_layout
        .topSpaceToView(contact, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(80);
        
        // 详细介绍
        introduce.sd_layout
        .topSpaceToView(self.tableView, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(40);
    }
    
    // 详细介绍的内容视图布局
    self.introduceLabel.sd_layout
    .topSpaceToView(introduce, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
    
    
    // 图片介绍
    imageIntroduce.sd_layout
    .topSpaceToView(self.introduceLabel, 15)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    
    CGFloat imageWidth = (SCREEN_WIDTH - 30 - 15) / 4;// 设置图片宽度，距离父视图左右两边各15point，图片之间间距为5point
    // 图片数组滚动视图
    UIScrollView *imageScroll = [[UIScrollView alloc] init];
    imageScroll.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageScroll];
    imageScroll.sd_layout
    .topSpaceToView(imageIntroduce, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(imageWidth + 20);
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = RGB(240, 240, 240);
        [self addSubview:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(self, 10 + i * (imageWidth + 5))
        .topSpaceToView(imageIntroduce, 15)
        .widthIs(imageWidth)
        .heightEqualToWidth();
    }
    
    // 文件下载
    fileDownload.sd_layout
    .topSpaceToView(imageScroll, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    UIImageView *docImage = [[UIImageView alloc] init];
    docImage.image = [UIImage imageNamed:@"doc50"];
    [self addSubview:docImage];
    docImage.sd_layout
    .widthIs(50)
    .heightEqualToWidth()
    .topSpaceToView(fileDownload, 10)
    .centerYIs(self.width_sd * 0.25);
    
    UIImageView *pdfImage = [[UIImageView alloc] init];
    pdfImage.image = [UIImage imageNamed:@"pdf50"];
    [self addSubview:pdfImage];
    pdfImage.sd_layout
    .widthIs(50)
    .heightEqualToWidth()
    .topSpaceToView(fileDownload, 10)
    .centerYIs(self.width_sd * 0.75);
    
    [self setupAutoHeightWithBottomViewsArray:@[docImage, pdfImage] bottomMargin:15];
}



#pragma mark - PGCDetailContactCellDelegate

- (void)detailContactCell:(PGCDetailContactCell *)cell phone:(UIButton *)phone
{
    if (self.delegate || [self.delegate respondsToSelector:@selector(detailSubviewBottom:callPhone:)]) {
        [self.delegate detailSubviewBottom:self callPhone:phone];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCDetailContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDetailContactCell];
    Contacts *contact = self.contactDatas[indexPath.row];
    cell.contact = contact;
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


#pragma mark - Event

- (void)cellCheckMore:(UIButton *)sender
{
    if (self.delegate || [self.delegate respondsToSelector:@selector(detailSubviewBottom:checkMoreContact:)]) {
        [self.delegate detailSubviewBottom:self checkMoreContact:sender];
    }
}


#pragma mark - Getter

- (NSMutableArray *)contactDatas {
    if (!_contactDatas) {
        _contactDatas = [NSMutableArray array];
    }
    return _contactDatas;
}

- (NSMutableArray *)imageDatas {
    if (!_imageDatas) {
        _imageDatas = [NSMutableArray array];
    }
    return _imageDatas;
}

- (NSMutableArray *)fileDatas {
    if (!_fileDatas) {
        _fileDatas = [NSMutableArray array];
    }
    return _fileDatas;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.showsHorizontalScrollIndicator = false;
        _tableView.bounces = false;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCDetailContactCell class] forCellReuseIdentifier:kPGCDetailContactCell];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UILabel *)introduceLabel {
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.textColor = RGB(102, 102, 102);
        _introduceLabel.font = SetFont(15);
        _introduceLabel.numberOfLines = 0;
        [self addSubview:_introduceLabel];
    }
    return _introduceLabel;
}


- (UIView *)checkMoreView{
    if (!_checkMoreView) {
        _checkMoreView = [[UIView alloc] init];
        _checkMoreView.backgroundColor = [UIColor whiteColor];
        _checkMoreView.bounds = CGRectMake(0, 0, self.width_sd, 40);
        UIImage *image = [UIImage imageNamed:@"加号"];
        NSString *title = @"查看更多联系人";
        CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
        
        UIButton *checkMoreContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkMoreContactBtn.bounds = CGRectMake(0, 0, image.size.width + titleSize.width + 30, _checkMoreView.height_sd);
        checkMoreContactBtn.center = _checkMoreView.center;
        [checkMoreContactBtn setImage:image forState:UIControlStateNormal];
        [checkMoreContactBtn.titleLabel setFont:SetFont(14)];
        [checkMoreContactBtn setTitle:title forState:UIControlStateNormal];
        [checkMoreContactBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
        [checkMoreContactBtn addTarget:self action:@selector(cellCheckMore:) forControlEvents:UIControlEventTouchUpInside];
        [_checkMoreView addSubview:checkMoreContactBtn];
        
        checkMoreContactBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        checkMoreContactBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    }
    return _checkMoreView;
}

@end
