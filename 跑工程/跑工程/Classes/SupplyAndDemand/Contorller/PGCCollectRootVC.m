//
//  PGCCollectRootVC.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCCollectRootVC.h"
#import "PGCNavigationItem.h"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ShareBtnTag,
    HeartBtnTag
};

@interface PGCCollectRootVC ()

@property (strong, nonatomic) PGCNavigationItem *shareBtn;
@property (strong, nonatomic) PGCNavigationItem *heartBtn;

@end

@implementation PGCCollectRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
    self.shareBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"share"] title:@"分享"];
    self.shareBtn.bounds = CGRectMake(0, 0, 40, 40);
    self.shareBtn.itemLabel.textColor = PGCTextColor;
    self.shareBtn.tag = ShareBtnTag;
    [self.shareBtn addTarget:self action:@selector(respondsToDetailItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.heartBtn = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"heart"] title:@"取消收藏"];
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
    static BOOL selected = true;
    
    if (sender.tag == HeartBtnTag) {
        
        selected = !selected;        
        [PGCProgressHUD showMessage:selected ? @"收藏成功!":@"取消收藏成功!" toView:self.view];
        
        self.heartBtn.itemLabel.text = selected ? @"取消收藏":@"收藏";
        
    } else {
        PGCSupplyAndDemandShareView *shareView = [[PGCSupplyAndDemandShareView alloc] init];
        shareView.delegate = self;
        [shareView showShareView];
    }
}


@end
