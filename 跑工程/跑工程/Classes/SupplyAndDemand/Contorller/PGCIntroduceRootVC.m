//
//  PGCIntroduceRootVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCIntroduceRootVC.h"

@interface PGCIntroduceRootVC ()

@end

@implementation PGCIntroduceRootVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.introduceTableView];
}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}


#pragma mark - Getter

- (UITableView *)introduceTableView {
    if (!_introduceTableView) {
        _introduceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _introduceTableView.backgroundColor = RGB(244, 244, 244);
        _introduceTableView.allowsMultipleSelectionDuringEditing = true;
        _introduceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _introduceTableView.dataSource = self;
        _introduceTableView.delegate = self;
        [_introduceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _introduceTableView;
}

@end
