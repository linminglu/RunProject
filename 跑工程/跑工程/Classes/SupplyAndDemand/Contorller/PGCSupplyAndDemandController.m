//
//  PGCSupplyAndDemandController.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandController.h"
#import "PGCSupplyAndDemandCell.h"
#import "PGCDropMenu.h"
#import "PGCSearchBar.h"
#import "PGCSupplyDetailVC.h"
#import "PGCDemandDetailVC.h"
#import "PGCDemandCollectVC.h"
#import "PGCSupplyCollectVC.h"
#import "PGCDemandIntroduceVC.h"
#import "PGCSupplyIntroduceVC.h"

#define TopButtonTag 500
#define CenterButtonTag 400

@interface PGCSupplyAndDemandController () <UITableViewDelegate, UITableViewDataSource, PGCDropMenuDataSource, PGCDropMenuDelegate>
{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
}

#pragma mark - 控件约束属性
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBtnX;// 我的收藏按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceBtnX;// 我的发布按钮X

#pragma mark - 控件属性
@property (weak, nonatomic) IBOutlet UIButton *demandBtn;// 顶部需求按钮
@property (weak, nonatomic) IBOutlet UIButton *supplyBtn;// 顶部供应按钮
@property (weak, nonatomic) IBOutlet UIView *centerBackView;// 搜索框背景
@property (weak, nonatomic) IBOutlet UIButton *conllectionBtn;// 我的收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *introduceBtn;// 我的发布按钮
@property (weak, nonatomic) IBOutlet UITableView *tableView;// 表格视图
@property (strong, nonatomic) UIView *filterView;// 顶部标题按钮绿色游标
@property (strong, nonatomic) PGCSearchBar *searchBar;// 搜索条
@property (nonatomic, assign) BOOL isSelected;// 选择按钮是否被点击
@property (assign, nonatomic) BOOL demandNotSupply;// 是否为需求信息


- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSupplyAndDemandController

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

- (void)initializeDataSource {
    _isSelected = false;
    _demandNotSupply = true;
    
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
                                              @{@"title":@"江苏", @"data":@[@"南京", @"1600", @"1700"]}]];
    
    _data2 = [NSMutableArray arrayWithArray:@[@{@"stage":@"基础材料", @"data":@[@"基础材料1", @"基础材料2", @"基础材料3"]},
                                              @{@"stage":@"砖墙、门窗材料", @"data":@[@"砖墙", @"门窗", @"砖墙、门窗材料"]},
                                              @{@"stage":@"机电设备", @"data":@[@"机电设备1", @"机电设备2", @"机电设备3", @"机电设备4"]},
                                              @{@"stage":@"防水保温材料", @"data":@[@"防水保温材料1", @"防水保温材料2", @"防水保温材料3"]},
                                              @{@"stage":@"照明系统相关材料", @"data":@[@"照明系统1", @"照明系统2", @"照明系统3"]},
                                              @{@"stage":@"环保绿化材料", @"data":@[@"环保绿化1", @"环保绿化2", @"环保绿化3"]},
                                              @{@"stage":@"洪水管标阀门", @"data":@[@"洪水管标1", @"洪水管标2", @"洪水管标3"]},
                                              @{@"stage":@"其他", @"data":@[@"其他1", @"其他2", @"其他3"]},
                                              @{@"stage":@"找分包", @"data":@[@"找分包1", @"找分包2"]},
                                              @{@"stage":@"找设计", @"data":@[@"找设计1", @"找设计2"]}]];
    
    _data3 = [NSMutableArray arrayWithArray:@[@"一天", @"三天", @"一周", @"一个月", @"三个月", @"半年", @"一年"]];
}

- (void)initializeUserInterface {
    self.navigationController.navigationBar.hidden = true;
    // 控件布局
    [self layoutSubView];
    
    // 设置需求按钮初始状态为选中，用户交互停用
    self.demandBtn.selected = true;
    self.demandBtn.userInteractionEnabled = false;
    
    // 添加游标
    self.filterView = [[UIView alloc] init];
    self.filterView.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 2 - 4, 2);
    self.filterView.center = CGPointMake(self.demandBtn.centerX, STATUS_AND_NAVIGATION_HEIGHT - 1);
    self.filterView.backgroundColor = PGCTintColor;
    [self.view addSubview:self.filterView];
    
    // 设置搜索条
    self.searchBar = [[PGCSearchBar alloc] init];
    self.searchBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 2 - 20, 32);
    self.searchBar.center = CGPointMake(self.centerBackView.width / 4, self.centerBackView.height / 2);
    self.searchBar.layer.cornerRadius = 15;
    self.searchBar.layer.masksToBounds = true;
    [self.centerBackView addSubview:self.searchBar];
    
    PGCDropMenu *menu = [[PGCDropMenu alloc] initWithOrigin:CGPointMake(0, self.centerBackView.bottom) height:40];
    menu.backgroundColor = [UIColor whiteColor];
    menu.dropTitles = @[@"地区", @"类别", @"时间"];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    [self.tableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
}

// 控件约束布局
- (void)layoutSubView {
    CGFloat buttonW = 70;
    
    self.introduceBtnX.constant =(SCREEN_WIDTH / 2 - buttonW * 2) / 3;
    self.collectionBtnX.constant =(SCREEN_WIDTH / 2 - buttonW * 2) / 3;
}

#pragma mark - xib按钮点击事件

- (void)actionWithButton:(UIButton *)button
             otherButton:(UIButton *)otherButton
                 enabled:(BOOL)enabled
                selected:(BOOL)selected {
    button.userInteractionEnabled = enabled;
    otherButton.userInteractionEnabled = !button.userInteractionEnabled;
    
    button.selected = selected;
    otherButton.selected = !button.selected;
}

/**
 需求和供应信息按钮点击事件
 
 @param sender
 */
- (IBAction)demandAndSupplyBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case TopButtonTag:
        {
            [self actionWithButton:self.demandBtn
                       otherButton:self.supplyBtn
                           enabled:false
                          selected:true];
            _demandNotSupply = true;
        }
            break;
        case TopButtonTag + 1:
        {
            [self actionWithButton:self.demandBtn
                       otherButton:self.supplyBtn
                           enabled:true
                          selected:false];
            _demandNotSupply = false;
        }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.filterView.centerX = sender.centerX;
    }];
}

/**
 我的收藏和发布按钮点击事件
 
 @param sender
 */
- (IBAction)collectionAndIntroduceBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case CenterButtonTag:
        {
            if (_demandNotSupply) {
                // 推送到 需求->我的收藏 界面
                PGCDemandCollectVC *demandCollectVC = [PGCDemandCollectVC new];
                
                [self.navigationController pushViewController:demandCollectVC animated:true];
                
            } else {
                // 推送到 供应->我的收藏 界面
                PGCSupplyCollectVC *supplyCollectVC = [PGCSupplyCollectVC new];
                
                [self.navigationController pushViewController:supplyCollectVC animated:true];
            }
        }
            break;
        case CenterButtonTag + 1:
        {
            if (_demandNotSupply) {
                // 推送到 需求->我的发布 界面
                PGCDemandIntroduceVC *demandIntroduceVC = [PGCDemandIntroduceVC new];
                
                [self.navigationController pushViewController:demandIntroduceVC animated:true];
                
            } else {
                // 推送到 供应->我的发布 界面
                PGCSupplyIntroduceVC *supplyIntroduceVC = [PGCSupplyIntroduceVC new];
                
                [self.navigationController pushViewController:supplyIntroduceVC animated:true];
            }
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
        if (leftOrRight == 1) {
            return _data2.count;
            
        }
        if (leftOrRight == 2) {
            return [_data2[leftSelectedRow][@"data"] count];
        }
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
        if (indexPath.leftOrRight == 1) {
            NSDictionary *menuDic = [_data2 objectAtIndex:indexPath.row];
            
            return [menuDic objectForKey:@"stage"];
        }
        if (indexPath.leftOrRight == 2)  {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
            
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
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
    else if (column == 1) {
        return true;
    }
    else {
        return false;
    }
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


#pragma mark - PGCDropDownMenuDelegate

- (void)dropMenu:(PGCDropMenu *)dropMenu didSelectRowAtIndexPath:(PGCIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.leftOrRight == 0) {
            
            _currentData1Index = indexPath.row;
            
            return;
        }
        
    } else if (indexPath.column == 1) {
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCSupplyAndDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyAndDemandCell];
    
    // 点击cell不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_demandNotSupply) {
        
        [self.navigationController pushViewController:[PGCDemandDetailVC new] animated:true];
    } else {
        
        [self.navigationController pushViewController:[PGCSupplyDetailVC new] animated:true];
    }
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

@end
