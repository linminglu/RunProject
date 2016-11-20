//
//  PGCFeedbackViewController.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCFeedbackViewController.h"

@interface PGCFeedbackViewController ()

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    
    self.navigationItem.title = @"意见反馈";
    
}


@end
