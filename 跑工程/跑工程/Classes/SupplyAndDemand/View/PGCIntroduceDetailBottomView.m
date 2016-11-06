//
//  PGCIntroduceDetailBottomView.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIntroduceDetailBottomView.h"
#import "PGCProjectDetailTagView.h"
#import "PGCIntroduceAddContactCell.h"

@interface PGCIntroduceDetailBottomView () <UITableViewDataSource, UITableViewDelegate>

/**
 添加联系人表格
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 联系人数组
 */
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation PGCIntroduceDetailBottomView

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.bounces = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.sectionFooterHeight = 40;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[PGCIntroduceAddContactCell class] forCellReuseIdentifier:kIntroduceAddContactCell];
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

    
    UITextView *introduceTextView = [[UITextView alloc] init];
    introduceTextView.textColor = RGB(102, 102, 102);
    introduceTextView.font = SetFont(14);
    introduceTextView.text = @"我们公司主要经营的是什么什么样的业务和服务，有需要的请联系我们。";
    introduceTextView.returnKeyType = UIReturnKeyDefault;
    introduceTextView.enablesReturnKeyAutomatically = true;
    [self addSubview:introduceTextView];
    introduceTextView.sd_layout
    .topSpaceToView(introduce, 5)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(80);
    
    
    PGCProjectDetailTagView *imageIntroduce = [[PGCProjectDetailTagView alloc] initWithTitle:@"图片介绍"];
    [self addSubview:imageIntroduce];
    imageIntroduce.sd_layout
    .topSpaceToView(introduceTextView, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    
    UIImage *delete = [UIImage imageNamed:@"删除"];
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [deleteBtn setImage:delete forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    deleteBtn.sd_layout
    .topSpaceToView(imageIntroduce, 10)
    .rightSpaceToView(self, 15)
    .heightIs(delete.size.height)
    .widthIs(delete.size.width);
    
    
    UIImage *addImage = [UIImage imageNamed:@"加照片"];
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setImage:addImage forState:UIControlStateNormal];
    [self addSubview:imageBtn];
    imageBtn.sd_layout
    .topSpaceToView(imageIntroduce, 10)
    .leftSpaceToView(self, 15)
    .widthIs(addImage.size.width)
    .heightEqualToWidth();
    
    
    UILabel *imageIntroduceLabel = [[UILabel alloc] init];
    imageIntroduceLabel.textColor = PGCTextColor;
    [self addSubview:imageIntroduceLabel];
    imageIntroduceLabel.sd_layout
    .topSpaceToView(imageBtn, 10)
    .leftSpaceToView(self, 15)
    .widthRatioToView(imageBtn, 1.0)
    .autoHeightRatio(0);
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(240, 240, 240);
    [self addSubview:line];
    line.sd_layout
    .topSpaceToView(imageIntroduceLabel, 10)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    
    UIImage *add = [UIImage imageNamed:@"加号"];
    NSString *moreImage = @"添加更多照片";
    CGSize imageSize = [moreImage sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    UIButton *addMoreImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMoreImageBtn setImage:add forState:UIControlStateNormal];
    [addMoreImageBtn.titleLabel setFont:SetFont(14)];
    [addMoreImageBtn setTitle:moreImage forState:UIControlStateNormal];
    [addMoreImageBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
    [addMoreImageBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addMoreImageBtn];
    addMoreImageBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(line, 0)
    .heightIs(40)
    .widthIs(add.size.width + imageSize.width + 30);
    
    addMoreImageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    addMoreImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    [self setupAutoHeightWithBottomView:addMoreImageBtn bottomMargin:0];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCIntroduceAddContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kIntroduceAddContactCell];
    [cell addContactTarget:self action:@selector(deleteContact:)];
    
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
    NSString *title = @"添加更多联系人";
    CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UIButton *checkMoreContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkMoreContactBtn setImage:image forState:UIControlStateNormal];
    [checkMoreContactBtn.titleLabel setFont:SetFont(14)];
    [checkMoreContactBtn setTitle:title forState:UIControlStateNormal];
    [checkMoreContactBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
    [checkMoreContactBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)deleteContact:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDetailBottomView:deleteContact:)]) {
        [self.delegate introduceDetailBottomView:self deleteContact:sender];
    }
}

- (void)addContact:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDetailBottomView:addContact:)]) {
        [self.delegate introduceDetailBottomView:self addContact:sender];
    }
}

- (void)addImage:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDetailBottomView:addImage:)]) {
        [self.delegate introduceDetailBottomView:self addImage:sender];
    }
}

- (void)deleteImage:(UIButton *)sender {
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDetailBottomView:deleteImage:)]) {
        [self.delegate introduceDetailBottomView:self deleteImage:sender];
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
