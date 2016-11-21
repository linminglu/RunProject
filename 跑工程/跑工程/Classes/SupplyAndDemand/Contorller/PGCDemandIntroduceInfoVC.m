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
#import "PGCDemand.h"

@interface PGCDemandIntroduceInfoVC () <UITableViewDataSource, UITableViewDelegate, IntroduceDemandTopCellDelegate, IntroduceDemandContactCellDelegate>

@property (strong, nonatomic) UITableView *tableView;/** 表格试图 */
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.tableView];
    
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
//    PGCManager *manager = [PGCManager manager];
//    [manager readTokenData];
//    PGCUser *user = manager.token.user;
//    [self.params setObject:@"iphone" forKey:@"client_type"];
//    [self.params setObject:manager.token.token forKey:@"token"];
//    [self.params setObject:@(user.user_id) forKey:@"user_id"];
//    
//    [PGCDemandAPIManager addOrMidifyDemandWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
//        
//    }];
}

- (void)addMoreContact:(UIButton *)sender
{
    
}


#pragma mark - IntroduceDemandTopCellDelegate

- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView selectArea:(UIButton *)sender
{
    PGCAreaAndTypeRootVC *areaVC = [[PGCAreaAndTypeRootVC alloc] init];
    [self.navigationController pushViewController:areaVC animated:true];
}

- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView slectDemand:(UIButton *)demand
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark - IntroduceDemandContactCellDelegate

- (void)introduceDemandContactCell:(IntroduceDemandContactCell *)cell deleteBtn:(UIButton *)deleteBtn
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1: return 1; break;
        case 2: return 1; break;
        case 3: return 1; break;
        default: return 1; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            IntroduceDemandContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandContactCell];
            contactCell.delegate = self;
            return contactCell;
        }
            break;
        case 2:
        {
            IntroduceDemandDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandDescCell];
            descCell.introduceDescs = @"";
            return descCell;
        }
            break;
        case 3:
        {
            IntroduceDemandImagesCell *imagesCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandImagesCell];
            return imagesCell;
        }
            break;
        default:
        {
            IntroduceDemandTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandTopCell];
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


#pragma mark - Setter

- (void)setDemandDetail:(PGCDemand *)demandDetail
{
    _demandDetail = demandDetail;
    
    if (!demandDetail) {
        return;
    }
    [self.dataSource insertObject:@[demandDetail] atIndex:0];
    [self.dataSource insertObject:[@[demandDetail.contacts.firstObject] mutableCopy] atIndex:1];
    [self.dataSource insertObject:@[demandDetail.desc] atIndex:2];
    [self.dataSource insertObject:@[demandDetail.images] atIndex:3];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, self.view.height_sd - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[IntroduceDemandTopCell class] forCellReuseIdentifier:kIntroduceDemandTopCell];
        [_tableView registerClass:[IntroduceDemandContactCell class] forCellReuseIdentifier:kIntroduceDemandContactCell];
        [_tableView registerClass:[IntroduceDemandDescCell class] forCellReuseIdentifier:kIntroduceDemandDescCell];
        [_tableView registerClass:[IntroduceDemandImagesCell class] forCellReuseIdentifier:kIntroduceDemandImagesCell];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
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
