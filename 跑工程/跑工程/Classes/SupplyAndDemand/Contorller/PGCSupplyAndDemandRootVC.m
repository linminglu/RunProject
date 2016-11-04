//
//  PGCSupplyAndDemandRootVC.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandRootVC.h"

@interface PGCSupplyAndDemandRootVC ()

@end

@implementation PGCSupplyAndDemandRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.rootTableView];
}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}


#pragma mark - Getter

- (UITableView *)rootTableView {
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _rootTableView.backgroundColor = RGB(244, 244, 244);
        _rootTableView.allowsMultipleSelectionDuringEditing = true;
        _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTableView.dataSource = self;
        _rootTableView.delegate = self;
        [_rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _rootTableView;
}


@end
