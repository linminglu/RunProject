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
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"

@interface PGCAreaAndTypeRootVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *leftTableView;/** 左边表格视图 */
@property (strong, nonatomic) UITableView *rightTableView;/** 右边表格视图 */
@property (nonatomic, assign) NSInteger leftSelectedRow;/** 选中左边表的行数 */

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
    _leftSelectedRow = 0;    
    _isSelected = false;
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
    if (tableView == self.leftTableView) {
        return _dataSource.count;
    }
    if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
        
        PGCProvince *province = _dataSource[_leftSelectedRow];
        return province.cities.count;
    }
    PGCMaterialServiceTypes *type = _dataSource[_leftSelectedRow];
    return type.secondArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        PGCDropLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDropLeftCell];
        
        if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
            
            PGCProvince *province = _dataSource[indexPath.row];
            cell.leftTitleLabel.text = province.province;
        } else {
            PGCMaterialServiceTypes *type = _dataSource[indexPath.row];
            cell.leftTitleLabel.text = type.name;
        }
        return cell;
    }
    PGCDropRightCell *cell = [tableView dequeueReusableCellWithIdentifier:kPGCDropRightCell];
    
    if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
        
        PGCProvince *province = _dataSource[_leftSelectedRow];
        PGCCity *city = province.cities[indexPath.row];
        cell.rightTitleLabel.text = city.city;
    } else {
        PGCMaterialServiceTypes *type = _dataSource[_leftSelectedRow];
        PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];
        cell.rightTitleLabel.text = secondType.name;
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断是否为 左侧 的 tableView
    if (tableView == self.leftTableView) {
        _leftSelectedRow = indexPath.row;
        
        [self.rightTableView reloadData];
        
        if ([self.rightTableView numberOfRowsInSection:0] == 0) {
            
            if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
                PGCProvince *province = _dataSource[_leftSelectedRow];
                
                self.areaBlock(province, nil);
            } else {
                PGCMaterialServiceTypes *type = _dataSource[_leftSelectedRow];
                
                self.typeBlock([@[type] mutableCopy]);
            }
            [self.navigationController popViewControllerAnimated:true];
        }        
    }
    if (tableView == self.rightTableView) {
        
        if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
            
            PGCProvince *province = _dataSource[_leftSelectedRow];
            PGCCity *city = province.cities[indexPath.row];
            
            self.areaBlock(province, city);
            
        } else {
            PGCMaterialServiceTypes *type = _dataSource[_leftSelectedRow];
            PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];
            
            self.typeBlock([@[secondType] mutableCopy]);
        }
        [self.navigationController popViewControllerAnimated:true];
    }
}


@end
