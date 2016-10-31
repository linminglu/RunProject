//
//  PGCCollectViewController.m
//  跑工程
//
//  Created by leco on 2016/10/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCCollectViewController.h"
#import "PGCProjectInfoCell.h"
#import "PGCProjectInfoDetailViewController.h"

@interface PGCCollectViewController ()


- (void)initUserInterface; /** 初始化用户界面 */

@end

@implementation PGCCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

- (void)initUserInterface {
    self.navigationItem.title = @"我的收藏";
    self.bottomBtnTitle = @"取消收藏";
    [self.tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kPGCProjectInfoCell];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCProjectInfoCell forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        return;
    }
    [self.navigationController pushViewController:[[PGCProjectInfoDetailViewController alloc] init] animated:true];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
