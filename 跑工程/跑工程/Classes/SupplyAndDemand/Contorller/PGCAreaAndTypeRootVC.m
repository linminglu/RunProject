//
//  PGCAreaAndTypeRootVC.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAreaAndTypeRootVC.h"
#import "PGCDropLeftCell.h"
#import "PGCDropRightCell.h"

@interface PGCAreaAndTypeRootVC () <UITableViewDataSource, UITableViewDelegate>
/**
 左边表格视图
 */
@property (strong, nonatomic) UITableView *leftTableView;
/**
 右边表格视图
 */
@property (strong, nonatomic) UITableView *rightTableView;
/**
 选中左边表的行数
 */
@property (nonatomic, assign) NSInteger leftSelectedRow;
/**
 是否选中
 */
@property (assign, nonatomic) BOOL isSelected;

@end

@implementation PGCAreaAndTypeRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUI];
}

- (void)initializeUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView.backgroundColor = [UIColor whiteColor];
    self.leftTableView.rowHeight = 45;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    [self.leftTableView registerClass:[PGCDropLeftCell class] forCellReuseIdentifier:kPGCDropLeftCell];
    [self.view addSubview:self.leftTableView];
    self.leftTableView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .widthRatioToView(self.view, 0.5)
    .bottomSpaceToView(self.view, 0);
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.rightTableView.backgroundColor = RGB(240, 240, 240);
    self.rightTableView.rowHeight = 45;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    [self.rightTableView registerClass:[PGCDropRightCell class] forCellReuseIdentifier:kPGCDropRightCell];
    [self.view addSubview:self.leftTableView];
    self.rightTableView.sd_layout
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .widthRatioToView(self.view, 0.5)
    .bottomSpaceToView(self.view, 0);
    
    self.isSelected = false;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.leftTableView == tableView) {
        PGCDropLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDropLeftCell];
        cell.leftTitleLabel.text = @"左边";
        
        return cell;
    }
    else {
        PGCDropRightCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDropRightCell];
        cell.rightTitleLabel.text = @"右边";
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.leftTableView == tableView) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.leftSelectedRow inSection:0];
        
        [self.leftTableView selectRowAtIndexPath:selectedIndexPath animated:false scrollPosition:UITableViewScrollPositionNone];
        
        [self.rightTableView reloadData];
    }
}


@end
