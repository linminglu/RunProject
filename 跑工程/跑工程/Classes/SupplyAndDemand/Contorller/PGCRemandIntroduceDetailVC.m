//
//  PGCRemandIntroduceDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCRemandIntroduceDetailVC.h"

@interface PGCRemandIntroduceDetailVC ()

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCRemandIntroduceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"需求发布详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
}


@end
