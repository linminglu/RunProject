//
//  PGCRecordViewController.m
//  跑工程
//
//  Created by leco on 2016/10/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCRecordViewController.h"
#import "PGCProjectInfoDetailViewController.h"

@interface PGCRecordViewController ()

- (void)initUserInterface; /** 初始化用户界面 */

@end

@implementation PGCRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUserInterface];
}

- (void)initUserInterface {
    self.navigationItem.title = @"浏览记录";
    self.bottomBtnTitle = @"删除";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectInfoCell];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        return;
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false];
    
    [self.navigationController pushViewController:[[PGCProjectInfoDetailViewController alloc] init] animated:true];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
