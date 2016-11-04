//
//  PGCProjectAddContactController.m
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectAddContactController.h"
#import "PGCAddContactTableCell.h"
#import "PGCProjectDetailTagView.h"
#import "PGCHintAlertView.h"

@interface PGCProjectAddContactController () <UITableViewDataSource, UITableViewDelegate>
/**
 表格视图的头视图标题
 */
@property (copy, nonatomic) NSArray *headerTitles;
/**
 表格视图的数据源
 */
@property (copy, nonatomic) NSArray *dataSource;
/**
 文本输入框的提示语
 */
@property (copy, nonatomic) NSArray *placeholders;
/**
 表格视图
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 初始化数据源
 */
- (void)initializeDataSource;
/**
 初始化用户界面
 */
- (void)initializeUserInterface;

@end

@implementation PGCProjectAddContactController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    _headerTitles = @[@"联系方式", @"详细信息", @"备注"];
    
    _dataSource = @[@[@"电   话：", @"传   真：", @"座   机：", @"邮   箱："],
                    @[@"职   位：", @"公   司：", @"地   址："],
                    @[@""]];
    
    _placeholders = @[@[@"请输入电话", @"请输入传真", @"请输入座机", @"请输入邮箱"],
                      @[@"未填写", @"未填写", @"未填写"],
                      @[@""]];
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"添加联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToBarItemSave:)];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = PGCTextColor;
    nameLabel.font = SetFont(16);
    nameLabel.text = @"姓名：夏先生";
    [self.view addSubview:nameLabel];
    nameLabel.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(50);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = false;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.sd_layout
    .topSpaceToView(nameLabel, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headerTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {
        PGCAddContactTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddContactTableCell];
        if (!cell) {
            cell = [[PGCAddContactTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAddContactTableCell];
        }
        cell.addContactTitle.text = _dataSource[indexPath.section][indexPath.row];
        cell.addContactTF.placeholder = _placeholders[indexPath.section][indexPath.row];
        
        return cell;
    }
    else if (indexPath.section == 2) {
        PGCAddContactRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddContactRemarkCell];
        if (!cell) {
            cell = [[PGCAddContactRemarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAddContactRemarkCell];
        }
        
        return cell;
    }
    return [UITableViewCell new];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {
        return 45;
    }
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PGCProjectDetailTagView *tagView = [[PGCProjectDetailTagView alloc] initWithTitle:_headerTitles[section]];
    tableView.frame = CGRectMake(0, 0, tableView.width, 40);
    
    return tagView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [self makeButton];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 0;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        UITableView *tableView = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 40;
        CGFloat sectionFooterHeight = 40;
        
        CGFloat offsetY = tableView.contentOffset.y;
        
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }
        else if (offsetY >= sectionHeaderHeight
                 && offsetY <= tableView.contentSize.height - tableView.frame.size.height - sectionFooterHeight)
        {
            tableView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }
        else if (offsetY >= tableView.contentSize.height - tableView.frame.size.height - sectionFooterHeight
                 && offsetY <= tableView.contentSize.height - tableView.frame.size.height)
        {
            
            tableView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableView.contentSize.height - tableView.frame.size.height - sectionFooterHeight), 0);
            
        }
    }
}


- (UIButton *)makeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [button.titleLabel setFont:SetFont(14)];
    [button setTitle:@"添加其他的联系方式" forState:UIControlStateNormal];
    [button setTitleColor:PGCTintColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondsToAddOtherContact:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat imageInset = button.imageView.width;
    CGFloat titleInset = [button.titleLabel intrinsicContentSize].width / 2 - imageInset;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -imageInset, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -titleInset);
    
    return button;
}


#pragma mark - Events

- (void)respondsToAddOtherContact:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)respondsToBarItemSave:(UIBarButtonItem *)sender {
    PGCHintAlertView *hintAlert = [[PGCHintAlertView alloc] initWithContent:@"该联系人已成功添加到《通讯录》，方便你查找和联系。"];
    [hintAlert showHintAlertView];
}


@end
