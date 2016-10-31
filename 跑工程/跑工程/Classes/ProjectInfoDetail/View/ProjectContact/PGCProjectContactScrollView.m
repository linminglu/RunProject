//
//  PGCProjectContactScrollView.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectContactScrollView.h"
#import "PGCProjectDetailTagView.h"
#import "PGCProjectContactCell.h"

@interface PGCProjectContactScrollView () <UITableViewDataSource>

- (void)initUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectContactScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    // 项目概况
    PGCProjectDetailTagView *contactView = [[PGCProjectDetailTagView alloc] initWithFrame:CGRectZero title:@"联系人及其联系方式"];
    [self.contentView addSubview:contactView];
    // 开始自动布局
    contactView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(40);
    
    // 底部添加联系人视图
    UIButton *bottomBtn = [self makeButton];
    [self.contentView addSubview:bottomBtn];
    bottomBtn.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .heightIs(50);
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = RGB(230, 230, 250);
    [self.contentView addSubview:bottomLine];
    bottomLine.sd_layout
    .bottomSpaceToView(bottomBtn, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    // 联系人表格视图
    UITableView *contactTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contactTableView.rowHeight = 34 * 6 + 1;
    contactTableView.dataSource = self;
    [self.contentView addSubview:contactTableView];
    // 开始自动布局
    contactTableView.sd_layout
    .topSpaceToView(contactView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(bottomLine, 0);
}

- (UIButton *)makeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [button.titleLabel setFont:SetFont(14)];
    [button setTitle:@"查看更多联系人" forState:UIControlStateNormal];
    [button setTitleColor:PGCThemeColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondsToCheckContact:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelInset = [button.titleLabel intrinsicContentSize].width / 2 - button.imageView.width;
    CGFloat imageInset = button.imageView.width;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    return button;
}


#pragma mark - Events

- (void)respondsToCheckContact:(UIButton *)sender {
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kProjectContactCell = @"ProjectContactCell";
    
    PGCProjectContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectContactCell];
    if (!cell) {
        cell = [[PGCProjectContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProjectContactCell];
    }
    
    return cell;
}


@end
