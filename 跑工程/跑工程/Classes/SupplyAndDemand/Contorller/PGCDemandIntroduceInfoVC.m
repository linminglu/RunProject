//
//  PGCDemandIntroduceInfoVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandIntroduceInfoVC.h"
#import "PGCAreaAndTypeRootVC.h"
#import "PGCProjectDetailTagView.h"
#import "PGCDemandAPIManager.h"
#import "IntroduceDemandTopCell.h"
#import "IntroduceDemandContactCell.h"
#import "IntroduceDemandDescCell.h"
#import "IntroduceDemandImagesCell.h"
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"
#import "PGCDemand.h"

@interface PGCDemandIntroduceInfoVC () <IntroduceDemandTopCellDelegate, IntroduceDemandContactCellDelegate>

@property (copy, nonatomic) NSArray *headerTitles;/** 头部视图标题 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 表格视图数据源 */
@property (strong, nonatomic) UIButton *introduceBtn;/** 底部发布按钮 */
@property (strong, nonatomic) NSMutableDictionary *params;/** 参数字典 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCDemandIntroduceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource
{
    _headerTitles = @[@" ", @"联系人", @"详细介绍", @"图片介绍"];
}


- (void)initializeUserInterface
{
    self.navigationItem.title = @"需求信息";
    self.automaticallyAdjustsScrollViewInsets = false;
    
    CGRect rect = self.tableView.frame;
    rect = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
    self.tableView.frame = rect;
    
    self.tableView.backgroundColor = PGCBackColor;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[IntroduceDemandTopCell class] forCellReuseIdentifier:kIntroduceDemandTopCell];
    [self.tableView registerClass:[IntroduceDemandContactCell class] forCellReuseIdentifier:kIntroduceDemandContactCell];
    [self.tableView registerClass:[IntroduceDemandDescCell class] forCellReuseIdentifier:kIntroduceDemandDescCell];
    [self.tableView registerClass:[IntroduceDemandImagesCell class] forCellReuseIdentifier:kIntroduceDemandImagesCell];
    
    // 发布按钮
    self.introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.introduceBtn.backgroundColor = PGCTintColor;
    [self.introduceBtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.introduceBtn addTarget:self action:@selector(respondsToIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.introduceBtn];
    self.introduceBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(TAB_BAR_HEIGHT);
}



#pragma mark - Event

- (void)respondsToIntroduceBtn:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    [self.params setObject:@"iphone" forKey:@"client_type"];
    [self.params setObject:manager.token.token forKey:@"token"];
    [self.params setObject:@(user.user_id) forKey:@"user_id"];
    
    
    
    [PGCDemandAPIManager addOrMidifyDemandWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
        
    }];
}

- (void)addMoreContact:(UIButton *)sender
{
    Contacts *contact = [[Contacts alloc] init];
    [(NSMutableArray *)self.dataSource[1] addObject:contact];
    [self.tableView reloadData];
}


#pragma mark - IntroduceDemandTopCellDelegate

- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView selectArea:(UIButton *)area
{
    PGCAreaAndTypeRootVC *areaVC = [[PGCAreaAndTypeRootVC alloc] init];
    areaVC.navigationItem.title = @"选择地区";
    areaVC.dataSource = [[PGCAreaManager manager] setAreaData];
    [areaVC.dataSource removeObjectAtIndex:0];
    
    areaVC.block = ^(NSString *text) {
        [area setTitle:text forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:areaVC animated:true];
}

- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView slectDemand:(UIButton *)demand
{
    PGCAreaAndTypeRootVC *demandVC = [[PGCAreaAndTypeRootVC alloc] init];
    demandVC.navigationItem.title = @"选择需求类别";
    demandVC.dataSource = [[PGCMaterialServiceTypes materialServiceTypes] setMaterialTypes];
    [demandVC.dataSource removeObjectAtIndex:0];
    
    demandVC.block = ^(NSString *text) {
        [demand setTitle:text forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:demandVC animated:true];
}


#pragma mark - IntroduceDemandContactCellDelegate

- (void)introduceDemandContactCell:(IntroduceDemandContactCell *)cell deleteBtn:(UIButton *)deleteBtn
{
    NSMutableArray *array = (NSMutableArray *)self.dataSource[1];
    if (array.count > 1) {
        [array removeLastObject];
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            IntroduceDemandContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandContactCell];
            NSMutableArray *array = self.dataSource[indexPath.section];
            if (array.count > 1) {
                [contactCell setButtonHidden:false];
            } else {
                [contactCell setButtonHidden:true];
            }
            contactCell.contact = array[indexPath.row];
            contactCell.delegate = self;
            return contactCell;
        }
            break;
        case 2:
        {
            IntroduceDemandDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandDescCell];
            descCell.introduceDescs = [self.dataSource[indexPath.section] firstObject];
            return descCell;
        }
            break;
        case 3:
        {
            IntroduceDemandImagesCell *imagesCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandImagesCell];
            imagesCell.publishImages = [self.dataSource[indexPath.section] firstObject];
            return imagesCell;
        }
            break;
        default:
        {
            IntroduceDemandTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandTopCell];
            topCell.topDemand = [self.dataSource[indexPath.section] firstObject];
            topCell.delegate = self;
            return topCell;
        }
            break;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0;
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    return [[PGCProjectDetailTagView alloc] initWithTitle:_headerTitles[section]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) return 40;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIImage *image = [UIImage imageNamed:@"加号"];
        NSString *title = @"添加更多联系人";
        CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
        
        UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:footerBtn];
        
        footerBtn.frame = tableView.tableFooterView.frame;
        footerBtn.bounds = CGRectMake(0, 0, image.size.width + titleSize.width + 30, footerView.height_sd);
        footerBtn.center = footerView.center;
        [footerBtn setImage:image forState:UIControlStateNormal];
        [footerBtn.titleLabel setFont:SetFont(14)];
        [footerBtn setTitle:title forState:UIControlStateNormal];
        [footerBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
        [footerBtn addTarget:self action:@selector(addMoreContact:) forControlEvents:UIControlEventTouchUpInside];
        
        footerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        footerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
        
        return footerView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:self.tableView];
}


#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        if (!self.demandDetail) {
            self.demandDetail = [[PGCDemand alloc] init];
            NSMutableArray *contacts = [NSMutableArray array];
            [contacts addObject:[[Contacts alloc] init]];
            self.demandDetail.contacts = contacts;
            self.demandDetail.desc = @"";
            self.demandDetail.images = [NSMutableArray array];
        }
        [_dataSource insertObject:@[self.demandDetail] atIndex:0];
        [_dataSource insertObject:[@[self.demandDetail.contacts.firstObject] mutableCopy] atIndex:1];
        [_dataSource insertObject:@[self.demandDetail.desc] atIndex:2];
        [_dataSource insertObject:@[self.demandDetail.images] atIndex:3];
    }
    return _dataSource;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}


@end
