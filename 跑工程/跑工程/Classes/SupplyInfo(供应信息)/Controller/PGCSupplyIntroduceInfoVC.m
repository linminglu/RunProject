//
//  PGCSupplyIntroduceInfoVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyIntroduceInfoVC.h"
#import "PGCAreaAndTypeRootVC.h"
#import "PGCProjectDetailTagView.h"
#import "PGCSupplyAPIManager.h"
#import "IntroduceSupplyTopCell.h"
#import "IntroduceDemandContactCell.h"
#import "IntroduceDemandDescCell.h"
#import "IntroduceDemandImagesCell.h"
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"
#import "PGCSupply.h"

@interface PGCSupplyIntroduceInfoVC () <UITableViewDataSource, UITableViewDelegate, IntroduceSupplyTopCellDelegate, IntroduceDemandContactCellDelegate, IntroduceDemandImagesCellDelegate>

@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (copy, nonatomic) NSArray *headerTitles;/** 头部视图标题 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 表格视图数据源 */
@property (strong, nonatomic) UIButton *introduceBtn;/** 底部发布按钮 */
@property (strong, nonatomic) NSMutableDictionary *params;/** 参数字典 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSupplyIntroduceInfoVC

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
    self.navigationItem.title = @"供应信息";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.introduceBtn];
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

    
    
    [PGCSupplyAPIManager addOrMidifySupplyWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {

    }];
}

- (void)footerButtonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        Contacts *contact = [[Contacts alloc] init];
        [(NSMutableArray *)self.dataSource[sender.tag] addObject:contact];
    }
    if (sender.tag == 3) {
        Images *image = [[Images alloc] init];
        [(NSMutableArray *)self.dataSource[sender.tag] addObject:image];
    }
    [self.tableView reloadData];
}


#pragma mark - IntroduceSupplyTopCellDelegate

- (void)introduceSupplyTopCell:(IntroduceSupplyTopCell *)topView selectArea:(UIButton *)area
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

- (void)introduceSupplyTopCell:(IntroduceSupplyTopCell *)topView slectDemand:(UIButton *)demand
{
    PGCAreaAndTypeRootVC *demandVC = [[PGCAreaAndTypeRootVC alloc] init];
    demandVC.navigationItem.title = @"选择供应类别";
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSMutableArray *array = (NSMutableArray *)self.dataSource[1];
    if (array.count > 1) {
        [array removeObjectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}



#pragma mark - IntroduceDemandImagesCellDelegate

- (void)introduceDemandImagesCell:(IntroduceDemandImagesCell *)cell addImage:(id)addImage
{
    
}

- (void)introduceDemandImagesCell:(IntroduceDemandImagesCell *)cell deleteBtn:(UIButton *)deleteBtn
{
    NSMutableArray *array = (NSMutableArray *)self.dataSource[3];
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
            NSMutableArray *array = self.dataSource[indexPath.section];
            if (array.count > 1) {
                [imagesCell setButtonHidden:false];
            } else {
                [imagesCell setButtonHidden:true];
            }
            imagesCell.publishImage = array[indexPath.row];
            imagesCell.delegate = self;
            return imagesCell;
        }
            break;
        default:
        {
            IntroduceSupplyTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceSupplyTopCell];
            topCell.topSupply = [self.dataSource[indexPath.section] firstObject];
            topCell.delegate = self;
            return topCell;
        }
            break;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.001;
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return [[UIView alloc] init];
    return [[PGCProjectDetailTagView alloc] initWithTitle:_headerTitles[section]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 3) return 40;
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return [self footerViewTitle:@"添加更多联系人" section:section];
    }
    if (section == 3) {
        return [self footerViewTitle:@"添加更多照片" section:section];
    }
    return [[UIView alloc] init];
}

- (UIView *)footerViewTitle:(NSString *)title section:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"加号"];
    CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:footerBtn];
    footerBtn.tag = section;
    
    footerBtn.bounds = CGRectMake(0, 0, image.size.width + titleSize.width + 30, footerView.height_sd);
    footerBtn.center = footerView.center;
    [footerBtn setImage:image forState:UIControlStateNormal];
    [footerBtn.titleLabel setFont:SetFont(14)];
    [footerBtn setTitle:title forState:UIControlStateNormal];
    [footerBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    footerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    footerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:self.tableView];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.showsHorizontalScrollIndicator = false;
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[IntroduceSupplyTopCell class] forCellReuseIdentifier:kIntroduceSupplyTopCell];
        [_tableView registerClass:[IntroduceDemandContactCell class] forCellReuseIdentifier:kIntroduceDemandContactCell];
        [_tableView registerClass:[IntroduceDemandDescCell class] forCellReuseIdentifier:kIntroduceDemandDescCell];
        [_tableView registerClass:[IntroduceDemandImagesCell class] forCellReuseIdentifier:kIntroduceDemandImagesCell];
    }
    return _tableView;
}

- (UIButton *)introduceBtn {
    if (!_introduceBtn) {
        _introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _introduceBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
        _introduceBtn.backgroundColor = PGCTintColor;
        [_introduceBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_introduceBtn addTarget:self action:@selector(respondsToIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _introduceBtn;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        if (!self.supplyDetail) {
            self.supplyDetail = [[PGCSupply alloc] init];
            NSMutableArray *contacts = [NSMutableArray array];
            [contacts addObject:[[Contacts alloc] init]];
            self.supplyDetail.contacts = contacts;
            self.supplyDetail.desc = @"";
            NSMutableArray *images = [NSMutableArray array];
            [images addObject:[[Images alloc] init]];
            self.supplyDetail.images = images;
        }
        [_dataSource insertObject:@[self.supplyDetail] atIndex:0];
        [_dataSource insertObject:[@[self.supplyDetail.contacts.firstObject] mutableCopy] atIndex:1];
        [_dataSource insertObject:@[self.supplyDetail.desc] atIndex:2];
        [_dataSource insertObject:[@[self.supplyDetail.images.firstObject] mutableCopy] atIndex:3];
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
