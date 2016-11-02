//
//  PGCSupplyAndDemandController.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandController.h"
#import "PGCSupplyAndDemandCell.h"
#import "NSString+Size.h"
#import "PGCSupplyAndDemandDetailVC.h"

#import "PGCDemandCollectVC.h"
#import "PGCSupplyCollectVC.h"

#import "PGCDemandIntroduceVC.h"
#import "PGCSupplyIntroduceVC.h"

#define TopButtonTag 500
#define CenterButtonTag 400
#define ChooseButtonTag 300

@interface PGCSupplyAndDemandController () <UITableViewDelegate, UITableViewDataSource>


#pragma mark - 控件约束属性

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *demandBtnX;// 顶部需求按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SeparatorViewX;// 分割线X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supplyBtnX;// 顶部供应按钮X

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarW;// 搜索条宽度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceBtnX;// 我的发布按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBtnX;// 我的收藏按钮X

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseZoneBtnX;// 选择地区按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseTypeBtnX;// 选择类型按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseTimeBtnX;// 选择时间按钮X

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;// 按钮的宽度


#pragma mark - 控件属性

@property (weak, nonatomic) IBOutlet UIButton *demandBtn;// 顶部需求按钮
@property (weak, nonatomic) IBOutlet UIButton *supplyBtn;// 顶部供应按钮

@property (weak, nonatomic) IBOutlet UIButton *conllectionBtn;// 我的收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *introduceBtn;// 我的发布按钮

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;// 搜索条

@property (weak, nonatomic) IBOutlet UIButton *chooseZoneBtn;// 选择地区按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseTypeBtn;// 选择类型按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;// 选择时间按钮

@property (weak, nonatomic) IBOutlet UITableView *tableView;// 表格视图

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
    
    
}

- (void)initializeUserInterface {
    self.navigationController.navigationBar.hidden = true;
    // 控件布局
    [self layoutSubView];
    
    // 设置需求按钮初始状态为选中，用户交互停用
    self.demandBtn.selected = true;
    self.demandBtn.userInteractionEnabled = false;
    
    // 设置搜索条背景为透明
    self.searchBar.backgroundImage = [UIImage imageNamed:@"透明"];
    
    [self.tableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
}

// 控件约束布局
- (void)layoutSubView {
    self.demandBtnX.constant = (SCREEN_WIDTH / 2 - 100) / 2;
    self.SeparatorViewX.constant = SCREEN_WIDTH / 2 ;
    self.supplyBtnX.constant = (SCREEN_WIDTH / 2 - 100) / 2;
    self.searchBarW.constant = SCREEN_WIDTH / 2;
    self.introduceBtnX.constant =(SCREEN_WIDTH / 2 - 140) / 3;
    self.collectionBtnX.constant =(SCREEN_WIDTH / 2 - 140) / 3;
    
    CGFloat buttonW = [@"地区" sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width + [UIImage imageNamed:@"方向-right"].size.width;
    self.buttonWidth.constant = buttonW;
    self.chooseZoneBtnX.constant = (SCREEN_WIDTH - buttonW * 3) / 4;
    self.chooseTypeBtnX.constant = (SCREEN_WIDTH - buttonW * 3) / 4;
    self.chooseTimeBtnX.constant = (SCREEN_WIDTH - buttonW * 3) / 4;
    
    CGFloat labelInset = [self.chooseZoneBtn.titleLabel intrinsicContentSize].width - self.chooseZoneBtn.width - self.chooseZoneBtn.imageView.width;
    CGFloat imageInset = self.chooseZoneBtn.imageView.width - self.chooseZoneBtn.width - self.chooseZoneBtn.titleLabel.width;
    
    self.chooseZoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    self.chooseZoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    self.chooseTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    self.chooseTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    self.chooseTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    self.chooseTimeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
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
    PGCSupplyAndDemandDetailVC *detailVC = [PGCSupplyAndDemandDetailVC new];
        
    if (_demandNotSupply) {
        detailVC.detailVCTitle = @"需求信息详情";
    } else {
        detailVC.detailVCTitle = @"供应信息详情";
    }
    
    [self.navigationController pushViewController:detailVC animated:true];
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

/**
 三个选择按钮的点击事件

 @param sender
 */
- (IBAction)chooseBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    _isSelected = sender.selected;
    
    switch (sender.tag) {
        case ChooseButtonTag:
        {
            
        }
            break;
        case ChooseButtonTag + 1:
        {
            
        }
            break;
        case ChooseButtonTag + 2:
        {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

@end
