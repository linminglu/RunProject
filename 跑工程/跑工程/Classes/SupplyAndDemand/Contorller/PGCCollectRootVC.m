//
//  PGCCollectRootVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCCollectRootVC.h"

@interface PGCCollectRootVC ()

@end

@implementation PGCCollectRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.collectTableView];
}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}


#pragma mark - Getter

- (UITableView *)collectTableView {
    if (!_collectTableView) {
        _collectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _collectTableView.backgroundColor = RGB(244, 244, 244);
        _collectTableView.allowsMultipleSelectionDuringEditing = true;
        _collectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _collectTableView.dataSource = self;
        _collectTableView.delegate = self;
        [_collectTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _collectTableView;
}

@end
