//
//  PGCSupplyIntroduceVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyIntroduceVC.h"
#import "PGCSupplyAndDemandCell.h"
#import "PGCSupplyIntroduceDetailVC.h"

@interface PGCSupplyIntroduceVC ()

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSupplyIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"我的供应发布";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self barButtonItem]];
    
    [self.introduceTableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
}

- (UIButton *)barButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 80, 40);
    [button setImage:[UIImage imageNamed:@"发布信息"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:@"发布供应" forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToIntroduceInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    
    return button;
}


#pragma mark - Events

- (void)respondsToIntroduceInfo:(UIBarButtonItem *)sender {
    
}

#pragma mark - UITableViewDataSource

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
    
    PGCSupplyIntroduceDetailVC *detailVC = [PGCSupplyIntroduceDetailVC new];
    
    [self.navigationController pushViewController:detailVC animated:true];
}


@end
