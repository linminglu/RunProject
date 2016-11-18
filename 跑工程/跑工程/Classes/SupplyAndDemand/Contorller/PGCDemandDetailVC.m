//
//  PGCDemandDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandDetailVC.h"
#import "PGCDetailSubviewBottom.h"
#import "PGCDemand.h"
#import "PGCSupplyAndDemandAPIManager.h"
#import "PGCSupplyAndDemandShareView.h"
#import "PGCNavigationItem.h"
#import "PGCDetailTitleView.h"


#pragma mark -
#pragma mark - DemandDetailSubviewTop

@interface DemandDetailSubviewTop : UIView

@end

@implementation DemandDetailSubviewTop

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubviewsWithModel:model];
    }
    return self;
}

- (void)setupSubviewsWithModel:(id)model
{
    if (model == nil) {
        return;
    }
    NSArray *titleArr = model[@"title"];
    NSArray *contentArr = model[@"content"];
    
    PGCDetailTitleView *title = [[PGCDetailTitleView alloc] initWithTitle:titleArr[0] content:contentArr[0]];
    [self addSubview:title];
    title.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 灰色分割视图
    UIView *grayView_1 = [[UIView alloc] init];
    grayView_1.backgroundColor = RGB(244, 244, 244);
    [self addSubview:grayView_1];
    grayView_1.sd_layout
    .topSpaceToView(title, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(10);
    
    
    PGCDetailTitleView *time = [[PGCDetailTitleView alloc] initWithTitle:titleArr[1] content:contentArr[1]];
    [self addSubview:time];
    time.sd_layout
    .topSpaceToView(grayView_1, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 时间下面的分割线
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line_1];
    line_1.sd_layout
    .topSpaceToView(time, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    
    PGCDetailTitleView *unit = [[PGCDetailTitleView alloc] initWithTitle:titleArr[2] content:contentArr[2]];
    [self addSubview:unit];
    unit.sd_layout
    .topSpaceToView(line_1, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 采购单位下面的分割线
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line_2];
    line_2.sd_layout
    .topSpaceToView(unit, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    
    PGCDetailTitleView *address = [[PGCDetailTitleView alloc] initWithTitle:titleArr[3] content:contentArr[3]];
    [self addSubview:address];
    address.sd_layout
    .topSpaceToView(line_2, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 灰色分割视图
    UIView *grayView_2 = [[UIView alloc] init];
    grayView_2.backgroundColor = RGB(244, 244, 244);
    [self addSubview:grayView_2];
    grayView_2.sd_layout
    .topSpaceToView(address, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(10);
    
    
    PGCDetailTitleView *area = [[PGCDetailTitleView alloc] initWithTitle:titleArr[4] content:contentArr[4]];
    [self addSubview:area];
    area.sd_layout
    .topSpaceToView(grayView_2, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 地区下面的分割线
    UIView *line_3 = [[UIView alloc] init];
    line_3.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line_3];
    line_3.sd_layout
    .topSpaceToView(area, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    
    PGCDetailTitleView *demand = [[PGCDetailTitleView alloc] initWithTitle:titleArr[5] content:contentArr[5]];
    [self addSubview:demand];
    demand.sd_layout
    .topSpaceToView(line_3, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    [self setupAutoHeightWithBottomView:demand bottomMargin:0];
}
@end


#pragma mark -
#pragma mark - DemandDetailSubviewBottom

@interface DemandDetailSubviewBottom : UIView

@end

@implementation DemandDetailSubviewBottom



@end


#pragma mark -
#pragma mark - PGCDemandDetailVC

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ShareBtnTag,
    HeartBtnTag
};

@interface PGCDemandDetailVC ()  < PGCDetailSubviewBottomDelegate, PGCSupplyAndDemandShareViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;/** 版块0 底部滚动视图 */
@property (strong, nonatomic) DemandDetailSubviewTop *topView;/** 板块视图1 */
@property (strong, nonatomic) PGCDetailSubviewBottom *bottomView;/** 板块视图2 */


- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCDemandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}


- (void)initializeUserInterface
{
    self.navigationItem.title = @"需求信息详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = RGB(244, 244, 244);
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.scrollView];
    
    
    NSString *start = [self.demand.start_time substringToIndex:10];
    NSString *end = [self.demand.end_time substringToIndex:10];
    NSArray *array = @[self.demand.title,
                       [NSString stringWithFormat:@"%@ 至 %@", start, end],
                       self.demand.company,
                       self.demand.address,
                       [self.demand.province stringByAppendingString:self.demand.city],
                       self.demand.type_name];
    NSDictionary *model = @{@"title":@[@"标题：",
                                       @"时间：",
                                       @"采购单位（个人）：",
                                       @"地址：",
                                       @"地区：",
                                       @"需求："],
                            @"content":array};
    // 版块1
    self.topView = [[DemandDetailSubviewTop alloc] initWithModel:model];
    [self.scrollView addSubview:self.topView];

    // 版块2
    self.bottomView = [[PGCDetailSubviewBottom alloc] initWithModel:self.demand];
    self.bottomView.delegate = self;
    [self.scrollView addSubview:self.bottomView];
    
    [self setPlateViewAutoLayout];
}

#pragma mark - 三方约束子控件

- (void)setPlateViewAutoLayout
{    
    self.scrollView.sd_layout
    .topSpaceToView(self.view, STATUS_AND_NAVIGATION_HEIGHT)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    // 第1个版块布局
    self.topView.sd_layout
    .topSpaceToView(self.scrollView, 0)
    .leftSpaceToView(self.scrollView, 0)
    .rightSpaceToView(self.scrollView, 0)
    .heightIs(10);// 给定初始高度，后面根据自身子视图计算高度
    
    // 第2个版块布局
    self.bottomView.sd_layout
    .topSpaceToView(self.topView, 0)
    .leftSpaceToView(self.scrollView, 0)
    .rightSpaceToView(self.scrollView, 0)
    .heightIs(10);
    
    [self.scrollView setupAutoHeightWithBottomView:self.bottomView bottomMargin:0];
}


#pragma mark - Event

- (void)respondsToDetailItem:(PGCNavigationItem *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    if (sender.tag == HeartBtnTag) {
        if (self.demand.collect_id == 0) {
            NSDictionary *params = @{@"user_id":@(user.user_id),
                                     @"client_type":@"iphone",
                                     @"token":manager.token.token,
                                     @"id":@(self.demand.id),
                                     @"type":@(2)};
            [PGCSupplyAndDemandAPIManager addSupplyDemandCollectWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
                if (status == RespondsStatusSuccess) {
                    self.demand.collect_id = [resultData intValue];
                    [PGCProgressHUD showMessage:@"收藏成功" toView:self.view];
                    sender.itemLabel.text = @"取消收藏";
                    [PGCNotificationCenter postNotificationName:kRefreshDemandAndSupplyData object:self.demand userInfo:nil];
                } else {
                    [PGCProgressHUD showMessage:message toView:self.view];
                }
            }];
        } else {
            NSString *ids_json = [NSString stringWithFormat:@"[%d]", self.demand.collect_id];
            NSDictionary *params = @{@"user_id":@(user.user_id),
                                     @"client_type":@"iphone",
                                     @"token":manager.token.token,
                                     @"ids_json":ids_json};
            [PGCSupplyAndDemandAPIManager deleteSupplyDemandCollectWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
                if (status == RespondsStatusSuccess) {
                    self.demand.collect_id = 0;
                    [PGCProgressHUD showMessage:@"已取消收藏" toView:self.view];
                    sender.itemLabel.text = @"收藏";
                    [PGCNotificationCenter postNotificationName:kRefreshDemandAndSupplyData object:self.demand userInfo:nil];
                } else {
                    [PGCProgressHUD showMessage:message toView:self.view];
                }
            }];
        }
    } else {
        PGCSupplyAndDemandShareView *shareView = [[PGCSupplyAndDemandShareView alloc] init];
        shareView.delegate = self;
        [shareView showShareView];
    }
}



#pragma mark - PGCDetailSubviewBottomDelegate

- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom checkMoreContact:(UIButton *)checkMoreContact
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom callPhone:(UIButton *)callPhone
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark - PGCSupplyAndDemandShareViewDelegate

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqFriend:(UIButton *)qqFriend {
    
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqZone:(UIButton *)qqZone {
    
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChat:(UIButton *)weChat {
    
}

- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChatFriends:(UIButton *)friends {
    
}



#pragma mark - Setter

- (void)setDemand:(PGCDemand *)demand
{
    _demand = demand;
    
    NSString *collectBtnTitle = demand.collect_id > 0 ? @"取消收藏" : @"收藏";
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
}


@end
