//
//  PGCSupplyIntroduceInfoVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyIntroduceInfoVC.h"

@interface PGCSupplyIntroduceInfoVC ()


- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */


@end

@implementation PGCSupplyIntroduceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"供应信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
}



@end
