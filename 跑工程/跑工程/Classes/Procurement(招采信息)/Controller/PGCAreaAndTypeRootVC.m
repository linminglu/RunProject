//
//  PGCAreaAndTypeRootVC.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAreaAndTypeRootVC.h"
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"
#import "BackgroundView.h"

@interface PGCAreaAndTypeRootVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *leftTableView;/** 左边表格视图 */
@property (strong, nonatomic) UITableView *rightTableView;/** 右边表格视图 */
@property (nonatomic, assign) NSInteger leftSelectedRow;/** 选中左边表的行数 */
@property (strong, nonatomic) NSMutableArray *selectTypes;/** 选择的类别数组 */

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
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}


- (void)popToViewController:(UIBarButtonItem *)sender
{
    if ((self.selectTypes.count > 0)) {
        self.typeBlock(self.selectTypes);
    }
    [self.navigationController popViewControllerAnimated:true];
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
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!tableCell) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        BackgroundView *bg = [[BackgroundView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        tableCell.selectedBackgroundView = bg;
        tableCell.textLabel.highlightedTextColor = PGCTintColor;
        tableCell.textLabel.textColor = PGCTextColor;
        tableCell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if (tableView == self.leftTableView) {
        UIImage *nor_image = [UIImage imageNamed:@"icon_chose_arrow_nor"];
        UIImage *sel_image = [UIImage imageNamed:@"icon_chose_arrow_sel"];
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:nor_image highlightedImage:sel_image];
        
        if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
            PGCProvince *province = _dataSource[indexPath.row];
            tableCell.textLabel.text = province.province;
            tableCell.accessoryView = province.cities.count > 0 ? accessoryView : nil;
            
        } else {
            PGCMaterialServiceTypes *type = _dataSource[indexPath.row];
            tableCell.textLabel.text = type.name;
            tableCell.accessoryView = type.secondArray.count > 0 ? accessoryView : nil;
        }
        BackgroundView *bgColor = [[BackgroundView alloc] init];
        bgColor.backgroundColor = RGB(245, 245, 245);
        tableCell.backgroundView = bgColor;
    } else {
        
        if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
            
            PGCProvince *province = _dataSource[_leftSelectedRow];
            PGCCity *city = province.cities[indexPath.row];
            tableCell.textLabel.text = city.city;
            
        } else {
            PGCMaterialServiceTypes *type = _dataSource[_leftSelectedRow];
            PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];
            tableCell.textLabel.text = secondType.name;
            
            if ([self.selectTypes containsObject:secondType]) {
                [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionNone];
            }
        }
        BackgroundView *bgColor = [[BackgroundView alloc] init];
        bgColor.backgroundColor = [UIColor whiteColor];
        tableCell.backgroundView = bgColor;
        tableCell.accessoryView = [[UIImageView alloc] initWithImage:nil highlightedImage:[UIImage imageNamed:@"选中-对号"]];
    }
    return tableCell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断是否为 左侧 的 tableView
    if (tableView == self.leftTableView) {
        _leftSelectedRow = indexPath.row;
        
        [self.rightTableView reloadData];
    }
    if (tableView == self.rightTableView) {
        
        if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCProvince class]]) {
            
            PGCProvince *province = _dataSource[_leftSelectedRow];
            PGCCity *city = province.cities[indexPath.row];
            
            self.areaBlock(province, city);
            [self.navigationController popViewControllerAnimated:true];
            
        } else {
            PGCMaterialServiceTypes *type = _dataSource[_leftSelectedRow];
            PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];
            
            if (_isSupply) {
                if (![self.selectTypes containsObject:secondType]) {
                    [self.selectTypes addObject:secondType];
                }
            } else {
                self.typeBlock([@[secondType] mutableCopy]);
                [self.navigationController popViewControllerAnimated:true];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.rightTableView) {
        
        if ([_dataSource[_leftSelectedRow] isKindOfClass:[PGCMaterialServiceTypes class]]) {
            
            PGCMaterialServiceTypes *type = _dataSource[_leftSelectedRow];
            PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];
            
            if ([self.selectTypes containsObject:secondType]) {
                [self.selectTypes removeObject:secondType];
            }
        }
    }
}


#pragma mark - Setter

- (void)setIsSupply:(BOOL)isSupply
{
    _isSupply = isSupply;
    
    self.rightTableView.allowsMultipleSelection = isSupply;
    if (isSupply) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(popToViewController:)];
    }
}


#pragma mark - Getter

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH / 2, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.rowHeight = 45;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH / 2, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _rightTableView.backgroundColor = RGB(240, 240, 240);
        _rightTableView.rowHeight = 45;
        _rightTableView.allowsMultipleSelection = true;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
    }
    return _rightTableView;
}

- (NSMutableArray *)selectTypes {
    if (!_selectTypes) {
        _selectTypes = [NSMutableArray array];
    }
    return _selectTypes;
}

@end
