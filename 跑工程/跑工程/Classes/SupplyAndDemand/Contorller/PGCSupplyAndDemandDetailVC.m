//
//  PGCSupplyAndDemandDetailVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandDetailVC.h"
#import "PGCNavigationItem.h"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ShareBtnTag,
    HeartBtnTag
};

@interface PGCSupplyAndDemandDetailVC ()

@property (strong, nonatomic) PGCNavigationItem *shareBtn;
@property (strong, nonatomic) PGCNavigationItem *heartBtn;


@end

@implementation PGCSupplyAndDemandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
    self.shareBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"share"] title:@"分享"];
    self.shareBtn.bounds = CGRectMake(0, 0, 40, 40);
    self.shareBtn.itemLabel.textColor = PGCTextColor;
    self.shareBtn.tag = ShareBtnTag;
    [self.shareBtn addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.heartBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"heart"] title:@"收藏"];
    self.heartBtn.bounds = CGRectMake(0, 0, 60, 40);
    self.heartBtn.itemLabel.textColor = PGCTextColor;
    self.heartBtn.tag = HeartBtnTag;
    [self.heartBtn addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.shareBtn],
                                                [[UIBarButtonItem alloc] initWithCustomView:self.heartBtn]];
}


#pragma mark - Events
/**
 导航栏右边按钮点击事件
 */
- (void)respondsToDetailItem:(PGCNavigationItem *)sender {
    static BOOL selected = false;
    
    if (sender.tag == HeartBtnTag) {
        
        selected = !selected;
        
        [self showDetailHUDWith:self.view title:selected ? @"收藏成功!":@"取消收藏成功!"];
        
        self.heartBtn.itemLabel.text = selected ? @"取消收藏":@"收藏";
        
    } else {
        PGCSupplyAndDemandShareView *shareView = [[PGCSupplyAndDemandShareView alloc] init];
        shareView.delegate = self;
        [shareView showShareView];
    }
}




#pragma mark - Public

- (void)showDetailHUDWith:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    
    [hud hideAnimated:true afterDelay:1.5f];
}


@end
