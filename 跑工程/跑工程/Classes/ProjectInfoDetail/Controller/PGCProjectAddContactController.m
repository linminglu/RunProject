//
//  PGCProjectAddContactController.m
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectAddContactController.h"
#import "PGCAddContactTableCell.h"
#import "PGCAddContactRemarkCell.h"
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
 联系人名字标签
 */
@property (strong, nonatomic) UILabel *nameLabel;
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
                    @[@"备注"]];
    
    _placeholders = @[@[@"请输入电话", @"请输入传真", @"请输入座机", @"请输入邮箱"],
                      @[@"未填写", @"未填写", @"未填写"],
                      @[@"请输入备注"]];
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"添加联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToBarItemSave:)];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = PGCTextColor;
    self.nameLabel.font = SetFont(16);
    self.nameLabel.text = @"姓名：夏先生";
    [self.view addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(50);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[PGCAddContactTableCell class] forCellReuseIdentifier:kAddContactTableCell];
    [self.tableView registerClass:[PGCAddContactRemarkCell class] forCellReuseIdentifier:kAddContactRemarkCell];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.nameLabel, 0)
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
        
        cell.addContactTitle.text = _dataSource[indexPath.section][indexPath.row];
        cell.addContactTF.placeholder = _placeholders[indexPath.section][indexPath.row];
        
        return cell;
    }
    else if (indexPath.section == 2) {
        PGCAddContactRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddContactRemarkCell];
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
    tagView.frame = CGRectMake(0, 0, tableView.width, 40);
    
    return tagView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, tableView.width, 40);
    footerView.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        UIImage *image = [UIImage imageNamed:@"加号"];
        NSString *title = @"添加其他的联系方式";
        CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
        
        UIButton *checkMoreContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkMoreContactBtn setImage:image forState:UIControlStateNormal];
        [checkMoreContactBtn.titleLabel setFont:SetFont(14)];
        [checkMoreContactBtn setTitle:title forState:UIControlStateNormal];
        [checkMoreContactBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
        [checkMoreContactBtn addTarget:self action:@selector(respondsToAddOtherContact:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:checkMoreContactBtn];
        checkMoreContactBtn.sd_layout
        .centerXEqualToView(footerView)
        .centerYEqualToView(footerView)
        .heightIs(40)
        .widthIs(image.size.width + titleSize.width + 30);
        
        checkMoreContactBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
        checkMoreContactBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        
        return footerView;
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



#pragma mark - Events

- (void)respondsToAddOtherContact:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)respondsToBarItemSave:(UIBarButtonItem *)sender {
    PGCHintAlertView *hintAlert = [[PGCHintAlertView alloc] initWithContent:@"该联系人已成功添加到《通讯录》，方便你查找和联系。"];
    [hintAlert showHintAlertView];
}


@end
