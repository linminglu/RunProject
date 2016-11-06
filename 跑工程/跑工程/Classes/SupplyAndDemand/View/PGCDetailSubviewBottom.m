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

@interface PGCDetailSubviewBottom () <UITableViewDataSource, UITableViewDelegate>

/**
 联系人表格视图
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 联系人数组
 */
@property (strong, nonatomic) NSMutableArray *dataSource;

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.bounces = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.sectionFooterHeight = 40;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[PGCDetailContactCell class] forCellReuseIdentifier:kPGCDetailContactCell];
    [self addSubview:self.tableView];
    // 联系人表格视图布局
    self.tableView.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40 + 40 + 80);
    
    
    PGCProjectDetailTagView *introduce = [[PGCProjectDetailTagView alloc] initWithTitle:@"详细介绍"];
    [self addSubview:introduce];
    introduce.sd_layout
    .topSpaceToView(self.tableView, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    
    // 详细介绍的内容
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.text = @"我们公司主要经营的是什么什么样的业务和服务，有需要的请联系我们";
    introduceLabel.textColor = RGB(102, 102, 102);
    introduceLabel.font = SetFont(15);
    introduceLabel.numberOfLines = 0;
    [self addSubview:introduceLabel];
    introduceLabel.sd_layout
    .topSpaceToView(introduce, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
    
    
    PGCProjectDetailTagView *imageIntroduce = [[PGCProjectDetailTagView alloc] initWithTitle:@"图片介绍"];
    [self addSubview:imageIntroduce];
    imageIntroduce.sd_layout
    .topSpaceToView(introduceLabel, 15)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    NSMutableArray<UIImageView *> *imageArray = [NSMutableArray array];
    
    CGFloat imageWidth = (SCREEN_WIDTH - 15 * 2 - 5 * 3) / 4;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = RGB(240, 240, 240);
        [self addSubview:imageView];
        [imageArray addObject:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(self, 15 + i * (imageWidth + 5))
        .topSpaceToView(imageIntroduce, 15)
        .widthIs(imageWidth)
        .heightEqualToWidth();
    }
    [self setupAutoHeightWithBottomViewsArray:imageArray bottomMargin:15];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCDetailContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDetailContactCell];
    cell.contactDic = self.dataSource[indexPath.row];
    [cell addTarget:self action:@selector(cellCallPhoneBtn:)];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PGCProjectDetailTagView *contact = [[PGCProjectDetailTagView alloc] initWithTitle:@"联系人"];
    contact.frame = CGRectMake(0, 0, tableView.width, 40);
    
    return contact;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"加号"];
    NSString *title = @"查看更多联系人";
    CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UIButton *checkMoreContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkMoreContactBtn setImage:image forState:UIControlStateNormal];
    [checkMoreContactBtn.titleLabel setFont:SetFont(14)];
    [checkMoreContactBtn setTitle:title forState:UIControlStateNormal];
    [checkMoreContactBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
    [checkMoreContactBtn addTarget:self action:@selector(cellCheckMore:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:checkMoreContactBtn];
    checkMoreContactBtn.sd_layout
    .centerXEqualToView(footerView)
    .topSpaceToView(footerView, 0)
    .heightIs(40)
    .widthIs(image.size.width + titleSize.width + 30);
    
    checkMoreContactBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    checkMoreContactBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    return footerView;
}


#pragma mark - Event

- (void)cellCheckMore:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(detailSubviewBottom:checkMoreContact:)]) {
        [self.delegate detailSubviewBottom:self checkMoreContact:sender];
    }
}

- (void)cellCallPhoneBtn:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(detailSubviewBottom:callPhone:)]) {
        [self.delegate detailSubviewBottom:self callPhone:sender];
    }
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@{@"name":@"某某", @"phone":@"188-8888-8888"}];
    }
    return _dataSource;
}


@end
