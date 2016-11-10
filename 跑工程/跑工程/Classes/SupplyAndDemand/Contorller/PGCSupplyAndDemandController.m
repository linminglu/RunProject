//
//  PGCSupplyAndDemandController.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandController.h"
#import "PGCSupplyAndDemandCell.h"
#import "JSDropDownMenu.h"
#import "PGCSearchBar.h"
#import "PGCSupplyDetailVC.h"
#import "PGCDemandDetailVC.h"
#import "PGCDemandCollectVC.h"
#import "PGCSupplyCollectVC.h"
#import "PGCDemandIntroduceVC.h"
#import "PGCSupplyIntroduceVC.h"
#import "PGCProvince.h"
#import "PGCMaterialServiceTypes.h"

#define TopButtonTag 500
#define CenterButtonTag 400

@interface PGCSupplyAndDemandController () <UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource, JSDropDownMenuDelegate>
{
    NSArray *_areaDatas;
    NSArray *_typeDatas;
    NSArray *_timeDatas;
    
    NSInteger _areaCurrentIndex;
    NSInteger _typeCurrentIndex;
    NSInteger _timeCurrentIndex;
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
    
    _areaDatas = [PGCProvince province].areaArray;
    _typeDatas = [PGCMaterialServiceTypes materialServiceTypes].typeArray;    
    _timeDatas = @[@"一天", @"三天", @"一周", @"一个月", @"三个月", @"半年", @"一年"];
}

- (void)initializeUserInterface {
    self.navigationController.navigationBar.hidden = true;
    // 控件布局
    [self layoutSubView];
    
    // 设置需求按钮初始状态为选中，用户交互停用
    self.demandBtn.selected = true;
    self.demandBtn.userInteractionEnabled = false;
    
    // 添加游标
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(1, STATUS_AND_NAVIGATION_HEIGHT - 2, SCREEN_WIDTH / 2 - 2, 2)];
    self.filterView.backgroundColor = PGCTintColor;
    [self.view addSubview:self.filterView];
    
    // 设置搜索条
    self.searchBar = [[PGCSearchBar alloc] init];
    self.searchBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 2 - 20, 34);
    self.searchBar.center = CGPointMake(SCREEN_WIDTH / 4, self.centerBackView.height / 2);
    self.searchBar.layer.cornerRadius = 20;
    self.searchBar.layer.masksToBounds = true;
    [self.centerBackView addSubview:self.searchBar];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, self.centerBackView.bottom) andHeight:40];
    menu.backgroundColor = [UIColor whiteColor];
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


#pragma mark - PGCDropMenuDaJSDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column {
    
    if (column < 2) {
        return true;
    }
    return false;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column {
    
    if (column < 2) {
        return 0.5;
    }
    return 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column {
    
    if (column == 0) {
        
        return _areaCurrentIndex;
        
    }
    if (column == 1) {
        
        return _typeCurrentIndex;
    }
    
    return _timeCurrentIndex;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    
    if (column == 0) {
        if (leftOrRight == 0) {
            
            return _areaDatas.count;
        }
        else {
            PGCProvince *province = _areaDatas[leftRow];
            NSArray *arr = province.city;
            
            return arr.count;
        }
    }
    else if (column == 1) {
        
        if (leftOrRight == 0) {
            return _typeDatas.count;
            
        }
        else {
            PGCMaterialServiceTypes *type = _typeDatas[leftRow];
            return type.secondArray.count;
        }
        
    }
    else if (column == 2) {
        return _timeDatas.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return @"地区";
            break;
        case 1: return @"类型";
            break;
        case 2: return @"时间";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.leftOrRight==0) {
            PGCProvince *province = _areaDatas[indexPath.row];
            return province.province;
            
        }
        else {
            PGCProvince *province = _areaDatas[indexPath.leftRow];
            NSArray *rightArr = province.city;
            PGCCity *city = rightArr[indexPath.row];

            return city.city;
        }
    }
    else if (indexPath.column == 1) {
        
        if (indexPath.leftOrRight == 0) {
            PGCMaterialServiceTypes *type = _typeDatas[indexPath.row];
            return type.name;
            
        }
        else{
            PGCMaterialServiceTypes *type = _typeDatas[indexPath.leftRow];
            PGCMaterialServiceTypes *secondType = type.secondArray[indexPath.row];

            return secondType.name;
        }
    }
    else {        
        return _timeDatas[indexPath.row];
    }
}



#pragma mark - JSDropDownMenuDelegatetaSource

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.leftOrRight == 0) {
            
            _areaCurrentIndex = indexPath.row;
            
            return;
        }
    }
    else if (indexPath.column == 1) {
        
        if (indexPath.leftOrRight == 0) {
            
            _typeCurrentIndex = indexPath.row;
            
            return;
        }
    }
    else{
        _timeCurrentIndex = indexPath.row;
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
