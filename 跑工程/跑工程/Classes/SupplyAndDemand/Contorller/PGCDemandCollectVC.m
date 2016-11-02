//
//  PGCDemandCollectVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandCollectVC.h"
#import "PGCSupplyAndDemandCell.h"
#import "PGCDemandCollectDetailVC.h"

@interface PGCDemandCollectVC ()

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCDemandCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"我的收藏";
    
    [self.collectTableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
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
    
    PGCDemandCollectDetailVC *detailVC = [PGCDemandCollectDetailVC new];
    
    [self.navigationController pushViewController:detailVC animated:true];
}


@end
