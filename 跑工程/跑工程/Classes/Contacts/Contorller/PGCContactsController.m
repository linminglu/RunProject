//
//  PGCContactsController.m
//  跑工程
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactsController.h"
#import "PGCContactsCell.h"
#import "PGCContactInfoController.h"
#import "PGCSearchContactCell.h"

@interface PGCContactsController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

#pragma mark - 控件
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *cancelBtn;

#pragma mark - 数据源
//初始数据源
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
//搜索条数据源
@property (nonatomic,strong) NSMutableArray *searchDataSourceArray;

@end


@implementation PGCContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = RGB(250, 117, 10);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
//    创建搜索条和取消按钮
    [self creatSearBar];
//    tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PGCContactsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PGCSearchContactCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
//    初始化数据
    self.dataSourceArray = [NSMutableArray array];
    [self.dataSourceArray addObject:@[@"张三",@"李四",@"王麻子",@"刘能"]];
    [self.dataSourceArray addObject:@[@"21",@"22",@"23",@"24"]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_cancelBtn.isHidden == NO) {
        return _searchDataSourceArray.count;
    }
        return self.dataSourceArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    搜索条在使用时
    if (_cancelBtn.isHidden == NO) {
        PGCSearchContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        if (!cell) {
            cell = [[PGCSearchContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.nameStr = self.searchDataSourceArray[indexPath.row];
        //        点击cell不变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
//    正常状态下
    PGCContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PGCContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
        //        解决视图重叠的BUG
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //        点击cell不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    去除cell分界线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//   数据源
    cell.contactsArray = self.dataSourceArray[indexPath.row];

//    创建点击事件
    for (int i = 0 ; i < cell.contactsArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40  + i * 70, SCREEN_WIDTH, 70)];
        [cell.contentView addSubview:btn];
        btn.titleLabel.text = cell.contactsArray[i];
        btn.tag = i;
        [btn addTarget:self action:@selector(contactInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cancelBtn.isHidden == NO) {
        return 70;
    }
    
    if (indexPath.row == 1) {
        return 40 + 330;
    }
    return 40 + 290;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cancelBtn.isHidden == NO) {
        PGCContactInfoController *contactInfoVC = [[PGCContactInfoController alloc] init];
        contactInfoVC.nameStr = _searchDataSourceArray[indexPath.row];
        [self.navigationController pushViewController:contactInfoVC animated:YES];
    }
}

- (void) creatSearBar
{
    //创建searBar，设置其属性
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 75, SCREEN_WIDTH - 20, 40)];
    [self.view addSubview:self.searchBar];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"透明"]];
    self.searchBar.backgroundImage = imageView.image;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.searchBar.layer.cornerRadius = 20;
    self.searchBar.placeholder = @"在联系人中搜索";
    self.searchBar.delegate = self;
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 85, 40, 20)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_cancelBtn];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_cancelBtn setHidden:YES];
    [_cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  
//    当开始输入文字时搜索条变短，右边出现取消按钮
    self.searchBar.frame = CGRectMake(10, 75, SCREEN_WIDTH - 70, 40);
    if (searchText.length > 0) {
        [_cancelBtn setHidden:NO];
        //    匹配搜索内容
        self.searchDataSourceArray = [NSMutableArray array];
        for (NSArray *array in self.dataSourceArray) {
            for (NSString *name in array) {
                NSString *nameStr = [name substringWithRange:NSMakeRange(0,1)];
                if ([searchText isEqualToString:name] || [searchText isEqualToString:nameStr]) {
                    [self.searchDataSourceArray addObject:name];
                }
//                每次匹配后都刷新界面
                [self.tableView reloadData];
            }
        }
    }
    
//    当没有输入文字时搜索条回归正常
    if (searchText.length == 0) {
        self.searchBar.frame = CGRectMake(10, 75, SCREEN_WIDTH - 20, 40);
        [_cancelBtn setHidden:YES];
        self.searchDataSourceArray = nil;
        [self.tableView reloadData];
    }
    
    
    
}

#pragma mark - 各个按钮点击事件
//进入联系人资料界面
- (void) contactInfo:(UIButton*) sender
{
    PGCContactInfoController *contactInfoVC = [[PGCContactInfoController alloc] init];
    contactInfoVC.nameStr = sender.titleLabel.text;
    [self.navigationController pushViewController:contactInfoVC animated:YES];
    
}

//取消搜索
- (void) cancelSearch
{
    [_cancelBtn setHidden:true];
    self.searchBar.frame = CGRectMake(10, 75, SCREEN_WIDTH - 20, 40);
    self.searchBar.text = nil;
    self.searchBar.userActivity = false;
    self.searchDataSourceArray = nil;
    [self.tableView reloadData];
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

@end
