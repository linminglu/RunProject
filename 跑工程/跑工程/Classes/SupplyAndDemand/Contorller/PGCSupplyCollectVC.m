//
//  PGCSupplyCollectVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyCollectVC.h"
#import "PGCSupplyAndDemandCell.h"
#import "PGCSupplyCollectDetailVC.h"

@interface PGCSupplyCollectVC ()

//@property (strong, nonatomic) UITableView *collectTableView;

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSupplyCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"我的收藏";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self barButtonItem]];
    
    [self.collectTableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
}

- (UIButton *)barButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 55, 40);
    [button setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToCollectEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelInset = [button.titleLabel intrinsicContentSize].width - button.imageView.width - button.width;
    CGFloat imageInset = button.imageView.width - button.width - button.titleLabel.width;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    return button;
}


#pragma mark - Event

- (void)respondsToCollectEdit:(UIBarButtonItem *)sender {
    
    self.collectTableView.editing = !self.collectTableView.editing;
}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCSupplyAndDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyAndDemandCell];
        
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        return;
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false];
    
    PGCSupplyCollectDetailVC *detailVC = [PGCSupplyCollectDetailVC new];
    
    [self.navigationController pushViewController:detailVC animated:true];
}


@end
