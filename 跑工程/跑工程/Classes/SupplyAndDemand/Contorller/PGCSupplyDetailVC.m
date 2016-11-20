//
//  PGCSupplyDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyDetailVC.h"
#import "PGCNavigationItem.h"
#import "PGCSupplyAndDemandAPIManager.h"
#import "PGCSupplyAndDemandShareView.h"
#import "PGCProjectDetailTagView.h"
#import "SupplyDetailTopCell.h"
#import "DemandDetailContactCell.h"
#import "DemandDetailDescCell.h"
#import "DemandDetailImagesCell.h"
#import "DemandDetailFilesCell.h"
#import "PGCAlertView.h"
#import "PGCHintAlertView.h"
#import "PGCProjectAddContactController.h"
#import "PGCProjectContact.h"
#import "PGCSupply.h"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ShareBtnTag,
    HeartBtnTag
};

@interface PGCSupplyDetailVC () <UITableViewDataSource, UITableViewDelegate, PGCSupplyAndDemandShareViewDelegate, DemandDetailContactCellDelegate, PGCAlertViewDelegate, PGCHintAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;/** 表格试图 */
@property (copy, nonatomic) NSArray *headerTitles;/** 头部视图标题 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 表格视图数据源 */
@property (strong, nonatomic) Contacts *contact;/** 联系人 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSupplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource
{
    _headerTitles = @[@" ", @"联系人", @"详细介绍", @"图片介绍", @"文件下载"];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"供应信息详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - Event

- (void)respondsToDetailItem:(PGCNavigationItem *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    if (sender.tag == HeartBtnTag) {
        if (self.supply.collect_id == 0) {
            NSDictionary *params = @{@"user_id":@(user.user_id),
                                     @"client_type":@"iphone",
                                     @"token":manager.token.token,
                                     @"id":@(self.supply.id),
                                     @"type":@(1)};
            [PGCSupplyAndDemandAPIManager addSupplyDemandCollectWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
                if (status == RespondsStatusSuccess) {
                    self.supply.collect_id = [resultData intValue];
                    [PGCProgressHUD showMessage:@"收藏成功" toView:self.view];
                    sender.itemLabel.text = @"取消收藏";
                    [PGCNotificationCenter postNotificationName:kRefreshDemandAndSupplyData object:self.supply userInfo:nil];
                } else {
                    [PGCProgressHUD showMessage:message toView:self.view afterDelayTime:1.5];
                }
            }];
        } else {
            NSString *ids_json = [NSString stringWithFormat:@"[%d]", self.supply.collect_id];
            NSDictionary *params = @{@"user_id":@(user.user_id),
                                     @"client_type":@"iphone",
                                     @"token":manager.token.token,
                                     @"ids_json":ids_json};
            [PGCSupplyAndDemandAPIManager deleteSupplyDemandCollectWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
                if (status == RespondsStatusSuccess) {
                    self.supply.collect_id = 0;
                    [PGCProgressHUD showMessage:@"已取消收藏" toView:self.view];
                    sender.itemLabel.text = @"收藏";
                    [PGCNotificationCenter postNotificationName:kRefreshDemandAndSupplyData object:self.supply userInfo:nil];
                } else {
                    [PGCProgressHUD showMessage:message toView:self.view afterDelayTime:1.5];
                }
            }];
        }
    } else {
        PGCSupplyAndDemandShareView *shareView = [[PGCSupplyAndDemandShareView alloc] init];
        shareView.delegate = self;
        [shareView showShareView];
    }
}

- (void)checkMoreContact:(UIButton *)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark - DemandDetailContactCellDelegate

- (void)demandDetailContactCell:(DemandDetailContactCell *)cell phone:(UIButton *)phone
{
    self.contact = nil;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.contact = (Contacts *)self.dataSource[indexPath.section][indexPath.row];
    
    NSString *nameStr = [NSString stringWithFormat:@"联系人：%@", self.contact.name];
    NSString *phoneStr = [NSString stringWithFormat:@"呼叫%@", self.contact.phone];
    
    PGCAlertView *alert = [[PGCAlertView alloc] initWithModel:@{@"name":nameStr, @"phone":phoneStr}];
    alert.delegate = self;
    [alert showAlertView];
}


#pragma mark - PGCAlertViewDelegate

- (void)alertView:(PGCAlertView *)alertView phone:(UIButton *)phone
{
    PGCHintAlertView *hintAlert = [[PGCHintAlertView alloc] initWithTitle:@"是否确定给联系人拨号？"];
    hintAlert.delegate = self;
    [hintAlert showHintAlertView];
}


- (void)alertView:(PGCAlertView *)alertView addContact:(UIButton *)addContact
{
    PGCProjectAddContactController *addContactVC = [[PGCProjectAddContactController alloc] init];
    NSDictionary *dic = @{@"name":self.contact.name, @"phone":self.contact.phone};
    addContactVC.projectCon = [PGCProjectContact mj_objectWithKeyValues:dic];
    [self.navigationController pushViewController:addContactVC animated:true];
}


#pragma mark - PGCHintAlertViewDelegate

- (void)hintAlertView:(PGCHintAlertView *)hintAlertView confirm:(UIButton *)confirm
{
    NSString *string = [NSString stringWithFormat:@"tel://%@", self.contact.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}



#pragma mark - PGCSupplyAndDemandShareViewDelegate

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqFriend:(UIButton *)qqFriend
{
    [PGCProgressHUD showMessage:@"分享供应信息到QQ好友成功!" toView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqZone:(UIButton *)qqZone
{
    [PGCProgressHUD showMessage:@"分享供应信息到QQ空间成功!" toView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChat:(UIButton *)weChat
{
    [PGCProgressHUD showMessage:@"分享供应信息到微信好友成功!" toView:self.view];
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChatFriends:(UIButton *)friends
{
    [PGCProgressHUD showMessage:@"分享供应信息到朋友圈成功!" toView:self.view];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) return 1;
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            DemandDetailContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:kDemandDetailContactCell];
            contactCell.contact = [self.dataSource[indexPath.section] firstObject];
            contactCell.delegate = self;
            return contactCell;
        }
            break;
        case 2:
        {
            DemandDetailDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:kDemandDetailDescCell];
            descCell.introduce = [self.dataSource[indexPath.section] firstObject];
            return descCell;
        }
            break;
        case 3:
        {
            DemandDetailImagesCell *imagesCell = [tableView dequeueReusableCellWithIdentifier:kDemandDetailImagesCell];
            imagesCell.imageDatas = [self.dataSource[indexPath.section] firstObject];
            return imagesCell;
        }
            break;
        case 4:
        {
            DemandDetailFilesCell *filesCell = [tableView dequeueReusableCellWithIdentifier:kDemandDetailFilesCell];
            filesCell.fileDatas = [self.dataSource[indexPath.section] firstObject];
            return filesCell;
        }
            break;
        default:
        {
            SupplyDetailTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:kSupplyDetailTopCell];
            topCell.topSupply = [self.dataSource[indexPath.section] firstObject];
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
    if ([self.dataSource[section] count] > 1) return 40;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIImage *image = [UIImage imageNamed:@"加号"];
        NSString *title = @"查看更多联系人";
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
        [footerBtn addTarget:self action:@selector(checkMoreContact:) forControlEvents:UIControlEventTouchUpInside];
        
        footerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        footerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
        
        return footerView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            Contacts *contact = [self.dataSource[indexPath.section] firstObject];
            return [tableView cellHeightForIndexPath:indexPath model:contact keyPath:@"contact" cellClass:[DemandDetailContactCell class] contentViewWidth:SCREEN_WIDTH];
        }
            break;
        case 2:
        {
            NSString *introduce = [self.dataSource[indexPath.section] firstObject];
            return [tableView cellHeightForIndexPath:indexPath model:introduce keyPath:@"introduce" cellClass:[DemandDetailDescCell class] contentViewWidth:SCREEN_WIDTH];
        }
            break;
        case 3:
        {
            NSArray *imageDatas = [self.dataSource[indexPath.section] firstObject];
            return [tableView cellHeightForIndexPath:indexPath model:imageDatas keyPath:@"imageDatas" cellClass:[DemandDetailImagesCell class] contentViewWidth:SCREEN_WIDTH];
        }
            break;
        case 4:
        {
            NSArray *fileDatas = [self.dataSource[indexPath.section] firstObject];
            return [tableView cellHeightForIndexPath:indexPath model:fileDatas keyPath:@"fileDatas" cellClass:[DemandDetailFilesCell class] contentViewWidth:SCREEN_WIDTH];
        }
            break;
        default:
        {
            PGCSupply *topSupply = [self.dataSource[indexPath.section] firstObject];
            return [tableView cellHeightForIndexPath:indexPath model:topSupply keyPath:@"topSupply" cellClass:[SupplyDetailTopCell class] contentViewWidth:SCREEN_WIDTH];
        }
            break;
    }
}



#pragma mark - Setter

- (void)setSupply:(PGCSupply *)supply
{
    _supply = supply;
    
    NSString *collectBtnTitle = supply.collect_id > 0 ? @"取消收藏" : @"收藏";
    PGCNavigationItem *heartBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"heart"] title:collectBtnTitle];
    heartBtn.bounds = CGRectMake(0, 0, 50, 40);
    heartBtn.itemLabel.textColor = PGCTextColor;
    heartBtn.tag = HeartBtnTag;
    [heartBtn addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    PGCNavigationItem *shareBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"share"] title:@"分享"];
    shareBtn.bounds = CGRectMake(0, 0, 30, 40);
    shareBtn.itemLabel.textColor = PGCTextColor;
    shareBtn.tag = ShareBtnTag;
    [shareBtn addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:shareBtn],
                                                [[UIBarButtonItem alloc] initWithCustomView:heartBtn]];
    
    [self.dataSource insertObject:@[supply] atIndex:0];
    [self.dataSource insertObject:supply.contacts atIndex:1];
    [self.dataSource insertObject:@[supply.desc] atIndex:2];
    [self.dataSource insertObject:@[supply.images] atIndex:3];
    [self.dataSource insertObject:@[supply.files] atIndex:4];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd, self.view.height_sd - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[SupplyDetailTopCell class] forCellReuseIdentifier:kSupplyDetailTopCell];
        [_tableView registerClass:[DemandDetailContactCell class] forCellReuseIdentifier:kDemandDetailContactCell];
        [_tableView registerClass:[DemandDetailDescCell class] forCellReuseIdentifier:kDemandDetailDescCell];
        [_tableView registerClass:[DemandDetailImagesCell class] forCellReuseIdentifier:kDemandDetailImagesCell];
        [_tableView registerClass:[DemandDetailFilesCell class] forCellReuseIdentifier:kDemandDetailFilesCell];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
