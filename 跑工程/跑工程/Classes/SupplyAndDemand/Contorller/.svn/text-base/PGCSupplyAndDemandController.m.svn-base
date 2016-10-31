//
//  PGCSupplyAndDemandController.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandController.h"
#import "PGCProjectInfoCell.h"

@interface PGCSupplyAndDemandController () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - 控件X

// 顶部需求按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *demandBtnX;
// 分割线X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SeparatorViewX;
// 顶部供应按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supplyBtnX;

// 搜索条宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarW;
// 我的发布按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceBtnX;
// 我的收藏按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBtnX;

// 选择地区按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseZoneBtnX;
// 选择类型按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseTypeBtnX;
// 选择时间按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseTimeBtnX;

#pragma mark - 控件
// 顶部需求按钮
@property (weak, nonatomic) IBOutlet UIButton *demandBtn;
// 顶部供应按钮
@property (weak, nonatomic) IBOutlet UIButton *supplyBtn;
// 我的收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *conllectionBtn;
// 我的发布按钮
@property (weak, nonatomic) IBOutlet UIButton *introduceBtn;
// 搜索条
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
// 选择地区按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseZoneBtn;
// 选择类型按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseTypeBtn;
// 选择时间按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;

// 选择地区按钮内的箭头
@property (nonatomic, strong) UIImageView *zoneArrowImage;
// 选择类型按钮内的箭头
@property (nonatomic, strong) UIImageView *typeArrowImage;
// 选择时间按钮内的箭头
@property (nonatomic, strong) UIImageView *timeArrowImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - 按钮状态标记
// 选择按钮是否被点击
@property (nonatomic, assign) BOOL zoneArrowAImageChange;
@property (nonatomic, assign) BOOL typeArrowAImageChange;
@property (nonatomic, assign) BOOL timeArrowAImageChange;

@end

@implementation PGCSupplyAndDemandController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = true;
    // 控件布局
    [self layoutSubView];
    // 设置需求按钮初始状态为选中，用户交互停用
    self.demandBtn.selected = YES;
    self.demandBtn.userInteractionEnabled = NO;
    
    // 设置搜索条背景为透明和两个按钮的圆角
    UIImage *image = [UIImage imageNamed:@"透明"];
    self.searchBar.backgroundImage = image;
    self.conllectionBtn.layer.cornerRadius = 15;
    self.conllectionBtn.layer.masksToBounds = YES;
    self.introduceBtn.layer.cornerRadius = 15;
    self.introduceBtn.layer.masksToBounds = YES;
    
    // 在选择地区，选择类型，选择时间按钮中添加子控件
    [self chooseBtnAddSubView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:@"PGCProjectInfoCell"];
}

// 控件布局
- (void) layoutSubView
{
    self.demandBtnX.constant = (SCREEN_WIDTH / 2 - 100 ) / 2;
    self.SeparatorViewX.constant = SCREEN_WIDTH / 2 ;
    self.supplyBtnX.constant = (SCREEN_WIDTH / 2 - 100 ) / 2;
    self.searchBarW.constant = SCREEN_WIDTH / 2;
    self.introduceBtnX.constant =(SCREEN_WIDTH / 2 - 140) / 3;
    self.collectionBtnX.constant =(SCREEN_WIDTH / 2 - 140) / 3;
    
    self.chooseZoneBtnX.constant = (SCREEN_WIDTH - 240) / 4;
    self.chooseTypeBtnX.constant = (SCREEN_WIDTH - 240) / 4;
    self.chooseTimeBtnX.constant = (SCREEN_WIDTH - 240) / 4;
}

// 给选择地区等3个按钮添加子控件
- (void)chooseBtnAddSubView;
{
    UILabel *zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 30, 20)];
    zoneLabel.font = [UIFont systemFontOfSize:14];
    zoneLabel.text = @"地区";
    [self.chooseZoneBtn addSubview:zoneLabel];
    _zoneArrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 15, 5, 10)];
    _zoneArrowImage.image = [UIImage imageNamed:@"right"];
    [self.chooseZoneBtn addSubview:_zoneArrowImage];
    
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 30, 20)];
    typeLabel.font = [UIFont systemFontOfSize:14];
    typeLabel.text = @"类型";
    [self.chooseTypeBtn addSubview:typeLabel];
    _typeArrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 15, 5, 10)];
    _typeArrowImage.image = [UIImage imageNamed:@"right"];
    [self.chooseTypeBtn addSubview:_typeArrowImage];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 30, 20)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = @"时间";
    [self.chooseTimeBtn addSubview:timeLabel];
    _timeArrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 15, 5, 10)];
    _timeArrowImage.image = [UIImage imageNamed:@"right"];
    [self.chooseTimeBtn addSubview:_timeArrowImage];

}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PGCProjectInfoCell" forIndexPath:indexPath];
    // 点击cell不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld-%ld", indexPath.row, indexPath.section);
}

#pragma mark xib按钮点击事件
// 顶部需求信息按钮点击事件
- (IBAction)demandBtnClick:(id)sender {
    
    self.demandBtn.userInteractionEnabled = NO;
    self.supplyBtn.userInteractionEnabled = YES;
    self.demandBtn.selected = YES;
    self.supplyBtn.selected = NO;
}

// 顶部供应信息按钮点击事件
- (IBAction)supplyBtnClick:(id)sender {
    self.demandBtn.userInteractionEnabled = YES;
    self.supplyBtn.userInteractionEnabled = NO;
    self.demandBtn.selected = NO;
    self.supplyBtn.selected = YES;
}

// 我的收藏按钮点击事件
- (IBAction)conllectionBtnClick:(id)sender {
    self.conllectionBtn.userInteractionEnabled = NO;
    self.introduceBtn.userInteractionEnabled = YES;
    self.conllectionBtn.selected = YES;
    self.introduceBtn.selected = NO;
}

// 我的发布按钮点击事件
- (IBAction)introduceBtnClick:(id)sender {
    self.conllectionBtn.userInteractionEnabled = YES;
    self.introduceBtn.userInteractionEnabled = NO;
    self.conllectionBtn.selected = NO;
    self.introduceBtn.selected = YES;
}

// 选择地区按钮点击事件
- (IBAction)chooseZoneBtnClick:(id)sender {
    // 新的frame和image
    self.zoneArrowImage.image = [UIImage imageNamed:@"方向-bottom"];
    self.zoneArrowImage.frame = CGRectMake(55, 17.5, 10, 5);
    _zoneArrowAImageChange = !_zoneArrowAImageChange;
    if (!_zoneArrowAImageChange) {
        self.zoneArrowImage.image = [UIImage imageNamed:@"right"];
        self.zoneArrowImage.frame = CGRectMake(60, 15, 5, 10);
    }
}

// 选择类型按钮点击事件
- (IBAction)chooseTypeBtnClick:(id)sender {
    // 新的frame和image
    self.typeArrowImage.image = [UIImage imageNamed:@"方向-bottom"];
    self.typeArrowImage.frame = CGRectMake(55, 17.5, 10, 5);
    _typeArrowAImageChange = !_typeArrowAImageChange;
    if (!_typeArrowAImageChange) {
        self.typeArrowImage.image = [UIImage imageNamed:@"right"];
        self.typeArrowImage.frame = CGRectMake(60, 15, 5, 10);
    }
}

// 选择时间按钮点击事件
- (IBAction)chooseTimeBtnClick:(id)sender {
    // 新的frame和image
    self.timeArrowImage.image = [UIImage imageNamed:@"方向-bottom"];
    self.timeArrowImage.frame = CGRectMake(55, 17.5, 10, 5);
    _timeArrowAImageChange = !_timeArrowAImageChange;
    if (!_timeArrowAImageChange) {
        self.timeArrowImage.image = [UIImage imageNamed:@"right"];
        self.timeArrowImage.frame = CGRectMake(60, 15, 5, 10);
    }
}

@end
