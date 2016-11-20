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
#import "PGCProvince.h"

@interface PGCAreaAndTypeRootVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *leftTableView;/** 左边表格视图 */
@property (strong, nonatomic) UITableView *rightTableView;/** 右边表格视图 */
@property (nonatomic, assign) NSInteger leftSelectedRow;/** 选中左边表的行数 */
@property (copy, nonatomic) NSArray<PGCProvince *> *dataSource;/** 数据源 */
@property (assign, nonatomic) BOOL isSelected;/** 是否选中 */

@end

@implementation PGCAreaAndTypeRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initializeUI];
}

- (void)initDataSource
{
    _isSelected = false;
    _dataSource = [PGCProvince province].areaArray;
}

- (void)initializeUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
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
    [self.view addSubview:self.rightTableView];
    self.rightTableView.sd_layout
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .widthRatioToView(self.view, 0.5)
    .bottomSpaceToView(self.view, 0);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.leftTableView == tableView) {
        return _dataSource.count;
    }
    
    PGCProvince *province = _dataSource[section];
    return province.city.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leftTableView == tableView) {
        PGCDropLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDropLeftCell];
        PGCProvince *province = _dataSource[indexPath.row];
        cell.leftTitleLabel.text = province.province;
        
        return cell;
    }
    
    PGCDropRightCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDropRightCell];
    PGCProvince *province = _dataSource[indexPath.row];
    PGCCity *city = province.city[indexPath.row];
    cell.rightTitleLabel.text = city.city;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leftTableView == tableView) {
        if (!_isSelected) {
            _isSelected = true;
            [self.leftTableView reloadData];
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelectedRow inSection:0];
            
            [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:false scrollPosition:UITableViewScrollPositionNone];
        }
        [self.rightTableView reloadData];
    }
}


@end
