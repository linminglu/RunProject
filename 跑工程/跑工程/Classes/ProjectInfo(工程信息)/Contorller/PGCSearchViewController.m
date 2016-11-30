//
//  PGCSearchViewController.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchViewController.h"
#import "PGCSearchView.h"
#import "PGCProjectInfoCell.h"
#import "PGCProjectInfoAPIManager.h"

#define SEARCH_PATH @"searchRecord.plist"

static NSString * const kSearchCell = @"SearchCell";

@interface PGCSearchViewController () <PGCSearchViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PGCSearchView *searchView;/** 搜索框 */
@property (strong, nonatomic) UIView *headerView;/** 历史记录视图 */
@property (strong, nonatomic) UITableView *tableView;/** 搜索结果表格视图 */
@property (strong, nonatomic) NSMutableArray *searchResults;/** 搜索结果 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSearchViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchView.searchTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.title = @"搜索";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
}


#pragma mark - Event

- (void)clearHistoryRecord:(UIButton *)sender
{
    [self.searchResults removeAllObjects];
    [self saveKeywordSearchRecord];
    
    [self.tableView reloadData];
}


#pragma mark - PGCSearchViewDelegate

- (void)searchView:(PGCSearchView *)searchView textFieldDidReturn:(UITextField *)textField
{
    [self.view endEditing:true];
    
    if (searchView.searchTextField.text.length > 0) {
        NSString *key_word = searchView.searchTextField.text;
        [self.searchResults addObject:key_word];
        [PGCNotificationCenter postNotificationName:kSearchProjectData object:nil userInfo:@{@"key_word":key_word}];
        
        [self saveKeywordSearchRecord];
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)searchView:(PGCSearchView *)searchView didSelectedSearchButton:(UIButton *)sender
{
    [self.view endEditing:true];
    
    if (searchView.searchTextField.text.length > 0) {
        NSString *key_word = searchView.searchTextField.text;
        [self.searchResults addObject:key_word];
        [PGCNotificationCenter postNotificationName:kSearchProjectData object:nil userInfo:@{@"key_word":key_word}];
        
        [self saveKeywordSearchRecord];
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [MBProgressHUD showError:@"请先输入关键字" toView:self.view];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchCell];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete_y24"]];
        cell.textLabel.textColor = RGB(102, 102, 102);
        cell.textLabel.text = self.searchResults[indexPath.row];
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, cell.contentView.height_sd - 1, SCREEN_WIDTH, 1);
        line.backgroundColor = PGCBackColor;
        [cell.contentView addSubview:line];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = false;
    
    NSString *key_word = self.searchResults[indexPath.row];
    
    [PGCNotificationCenter postNotificationName:kSearchProjectData object:nil userInfo:@{@"key_word":key_word}];
    
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Private

- (void)saveKeywordSearchRecord
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSString *tempPath = [documentPath stringByAppendingString:@"/searchCache"];
    NSString *searchRecord = [tempPath stringByAppendingPathComponent:SEARCH_PATH];
    
    if (![PGCFileManager fileExistsAtPath:tempPath]) {
        [PGCFileManager createDirectoryAtPath:tempPath withIntermediateDirectories:true attributes:nil error:nil];
    }
    if ([self.searchResults writeToFile:searchRecord atomically:true]) {
        NSLog(@"保存成功: %@, %@", searchRecord, self.searchResults);
    }
}

- (void)readKeywordSearchRecord
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSString *tempPath = [documentPath stringByAppendingString:@"/searchCache"];
    NSString *searchRecord = [tempPath stringByAppendingPathComponent:SEARCH_PATH];
    
    NSArray *readArr = [NSArray arrayWithContentsOfFile:searchRecord];
    
    if (readArr.count > 0) {
        [self.searchResults addObjectsFromArray:readArr];
        
        [self.tableView reloadData];
    }
}



#pragma mark - Getter

- (PGCSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[PGCSearchView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + 5, SCREEN_WIDTH, 35)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, self.searchView.bottom_sd + 5, SCREEN_WIDTH, 40);
        _headerView.backgroundColor = PGCBackColor;
        
        UILabel *leftLabel = [[UILabel alloc] init];
        NSString *text = @"历史记录";
        CGFloat textW = [text sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width;
        leftLabel.frame = CGRectMake(15, 0, textW, _headerView.height_sd);
        leftLabel.text = @"历史记录";
        leftLabel.textColor = PGCTintColor;
        leftLabel.font = SetFont(14);
        [_headerView addSubview:leftLabel];
        
        NSString *title = @"清除历史记录";
        CGFloat titleW = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width;
        titleW += 10;
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.frame = CGRectMake(_headerView.width_sd - titleW - 10, 0, titleW, _headerView.height_sd);
        rightBtn.titleLabel.font = SetFont(14);
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clearHistoryRecord:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:rightBtn];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom_sd, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.bottom_sd) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
        
        [self readKeywordSearchRecord];
    }
    return _searchResults;
}


@end
