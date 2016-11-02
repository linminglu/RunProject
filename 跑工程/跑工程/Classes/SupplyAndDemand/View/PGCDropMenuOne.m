//
//  PGCDropMenuOne.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropMenuOne.h"

@interface PGCDropMenuOne () <UITableViewDataSource, UITableViewDelegate>
/**
 半透明背景
 */
@property (strong, nonatomic) UIView *backgroundView;
/**
 左边表格视图
 */
@property (strong, nonatomic) UITableView *leftTable;
/**
 右边表格视图
 */
@property (strong, nonatomic) UITableView *rightTable;

@end

@implementation PGCDropMenuOne

- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height
{
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, SCREEN_SIZE.width, height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubviewWithOrigin:origin];
    }
    return self;
}

- (void)setupSubviewWithOrigin:(CGPoint)origin {
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _backgroundView.opaque = false;
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)]];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate


#pragma mark - Gesture

- (void)backgroundTapped:(UITapGestureRecognizer *)gesture {
    
}

@end
