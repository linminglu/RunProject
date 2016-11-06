//
//  PGCProjectInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoController.h"
#import "PGCProjectInfoNavigationBar.h"
#import "PGCProjectInfoCell.h"
#import "PGCMapTypeViewController.h"
#import "PGCRecordViewController.h"
#import "PGCCollectViewController.h"
#import "PGCProjectInfoDetailViewController.h"
#import "PGCDropMenu.h"


@interface PGCProjectInfoController () <UITableViewDataSource, UITableViewDelegate, PGCProjectInfoNavigationBarDelegate, PGCDropMenuDataSource, PGCDropMenuDelegate>
{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
}

@property (strong, nonatomic) UITableView *tableView;

- (void)initializeDataSource; /** 初始化数据 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectInfoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}


#pragma mark - Initialize

- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 自定义导航栏
    PGCProjectInfoNavigationBar *navigationBar = [[PGCProjectInfoNavigationBar alloc] init];
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
    
    
    PGCDropMenu *menu = [[PGCDropMenu alloc] initWithOrigin:CGPointMake(0, navigationBar.bottom) height:40];
    menu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menu];
    menu.dropTitles = @[@"地区", @"类别", @"阶段"];
    menu.dataSource = self;
    menu.delegate = self;
    
    // 表格视图
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kProjectInfoCell];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 开始自动布局
    tableView.sd_layout
    .topSpaceToView(menu, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, TAB_BAR_HEIGHT);
}

#pragma mark - 自动布局

- (void)setViewAutoLayout {
    
}


#pragma mark - PGCProjectInfoNavigationBarDelegate

- (void)projectInfoNavigationBar:(PGCProjectInfoNavigationBar *)projectInfoNavigationBar tapItem:(NSInteger)tag {
    switch (tag) {
        case mapItemTag:
        {
            [self.navigationController pushViewController:[PGCMapTypeViewController new] animated:true];
        }
            break;
        case recordItemTag:
        {
            [self.navigationController pushViewController:[PGCRecordViewController new] animated:true];
        }
            break;
        case collectItemTag:
        {
            [self.navigationController pushViewController:[PGCCollectViewController new] animated:true];
        }
            break;
        case searchItemTag:
        {
            PGCLog(@"搜索");
        }
            break;
        default:
            break;
    }
}


#pragma mark - PGCDropMenuDataSource

- (NSInteger)dropMenu:(PGCDropMenu *)dropMenu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftSelectedRow:(NSInteger)leftSelectedRow {
    if (column == 0) {
        if (leftOrRight == 1) {
            return _data1.count;
            
        }
        if (leftOrRight == 2) {
            return [_data1[leftSelectedRow][@"data"] count];
        }
    }
    else if (column == 1) {
        return _data2.count;
        
    }
    else if (column == 2) {
        return _data3.count;
        
    }
    return 0;
}

- (NSString *)dropMenu:(PGCDropMenu *)dropMenu titleForRowAtIndexPath:(PGCIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if (indexPath.leftOrRight == 1) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            
            return [menuDic objectForKey:@"title"];
        }
        if (indexPath.leftOrRight == 2)  {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    }
    else if (indexPath.column == 1) {
        return _data2[indexPath.row];
        
    }
    else if (indexPath.column == 2) {        
        return _data3[indexPath.row];
    }
    return nil;
}

- (BOOL)haveRightInColumn:(NSInteger)column {    
    if (column == 0) {
        return true;
    }
    return false;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column {
    
    if (column == 0) {
        return _currentData1Index;
        
    }
    if (column == 1) {
        return _currentData2Index;
    }    
    return 0;
}

- (BOOL)displayCollectionViewInColumn:(NSInteger)column {
    if (column == 2) {
        return true;
    }
    return false;
}


#pragma mark - PGCDropDownMenuDelegate

- (void)dropMenu:(PGCDropMenu *)dropMenu didSelectRowAtIndexPath:(PGCIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight == 0){
            
            _currentData1Index = indexPath.row;
            
            return;
        }
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectInfoCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.navigationController pushViewController:[PGCProjectInfoDetailViewController new] animated:true];
}


- (void)initializeDataSource {
    _data1 = [NSMutableArray arrayWithArray:@[@{@"title":@"全国", @"data":@[@"全国", @"1", @"2"]},
                                              @{@"title":@"当前城市", @"data":@[@"全国", @"10", @"20"]},
                                              @{@"title":@"热门城市", @"data":@[@"全国", @"100", @"200"]},
                                              @{@"title":@"重庆", @"data":@[@"重庆", @"1000", @"2000"]},
                                              @{@"title":@"四川", @"data":@[@"成都", @"10000", @"20000"]},
                                              @{@"title":@"贵州", @"data":@[@"贵阳", @"300", @"400"]},
                                              @{@"title":@"云南", @"data":@[@"昆明", @"500", @"600"]},
                                              @{@"title":@"广西", @"data":@[@"西宁", @"700", @"800"]},
                                              @{@"title":@"广东", @"data":@[@"广州", @"900", @"1100"]},
                                              @{@"title":@"福建", @"data":@[@"福州", @"1200", @"1300"]},
                                              @{@"title":@"浙江", @"data":@[@"杭州", @"1400", @"1500"]},
                                              @{@"title":@"江苏", @"data":@[@"南京", @"1600", @"1700"]}
                                              ]];
    
    _data2 = [NSMutableArray arrayWithArray:@[@"水利设施", @"基础设施（路灯照明）", @"道路桥梁（道路、桥梁、轨道、隧道）", @"工业建设（加工厂、仓库、厂房车间等）", @"住宅社区（住宅小区、公寓楼、别墅等）", @"行政办公（办公楼、行政楼、综合楼）", @"文体娱乐（教学楼、图书馆、体育馆、医院等）", @"商业综合（酒店商务、超市百货、广场等）"]];
    
    _data3 = [NSMutableArray arrayWithArray:@[@"工程筹备", @"勘探设计", @"施工招标", @"主体在建", @"设备安装", @"内外装修", @"竣工"]];
}


@end
