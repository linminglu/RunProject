//
//  PGCAppDelegate+RootController.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAppDelegate+RootController.h"
#import "PGCAppDelegate+AppService.h"
#import "PGCTabBarController.h"
#import "PGCOtherAPIManager.h"
#import "LunchImage.h"
#import "XHLaunchAd.h"
#import "PGCWebViewController.h"

#define IsSetup @"isSetup"

@interface PGCAppDelegate () <UIScrollViewDelegate>

@end

@implementation PGCAppDelegate (RootController)

// 初始化 window
- (void)setAppWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
}

// 设置根控制器
- (void)setRootViewController
{
    BOOL isSetup = [[NSUserDefaults standardUserDefaults] boolForKey:IsSetup];
    
    if (!isSetup) {//第一次安装
        self.window.rootViewController = [[UIViewController alloc] init];
        // 设置引导页
        [self createLoadingScrollView];
    } else {
        // 设置广告页
        [self createAdvertiseView];
    }
}

- (void)setRoot
{
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.rootViewController = [[PGCTabBarController alloc] init];
}


#pragma mark - 广告页

- (void)createAdvertiseView
{
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    [XHLaunchAd showWithAdFrame:self.window.bounds setAdImage:^(XHLaunchAd *launchAd) {
        launchAd.noDataDuration = 1;
        
        [PGCOtherAPIManager getLatestAppSplashImageRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, LunchImage *resultData) {
            if (status == RespondsStatusSuccess) {                
                NSString *imageUrl = [kBaseImageURL stringByAppendingString:resultData.image];
                //定义一个weakLaunchAd
                __weak __typeof(launchAd) weakLaunchAd = launchAd;
                [launchAd setImageUrl:imageUrl duration:3 skipType:SkipTypeTimeText options:XHWebImageRefreshCached completed:^(UIImage *image, NSURL *url) {
                    
                    weakLaunchAd.adFrame = self.window.bounds;
                } click:^{
                    
                }];
            }
        }];
    } showFinish:^{
        // 广告展示完成回调, 设置window根控制器
        [self setRoot];
    }];
}


#pragma mark - 引导页

- (void)createLoadingScrollView
{
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    sc.pagingEnabled = true;
    sc.delegate = self;
    sc.showsHorizontalScrollIndicator = false;
    sc.showsVerticalScrollIndicator = false;
    [self.window.rootViewController.view addSubview:sc];
    
    NSArray *images;
    
    if (SCREEN_WIDTH == 320) {
        images = @[@"工程信息640x1136",
                   @"供需信息640x1136",
                   @"项目足迹640x1136"];
    }
    if (SCREEN_WIDTH == 375) {
        images = @[@"工程信息750x1334",
                   @"供需信息750x1334",
                   @"项目足迹750x1334"];
    }
    if (SCREEN_WIDTH == 414) {
        images = @[@"工程信息1242x2208",
                   @"供需信息1242x2208",
                   @"项目足迹1242x2208"];
    }
    for (NSInteger i = 0; i < images.count; i++) {
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        img.image = [UIImage imageNamed:images[i]];
        [sc addSubview:img];
        img.userInteractionEnabled = true;
        
        if (i == images.count - 1) {
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
            [img addSubview:btn];
        }
    }
    sc.contentSize = CGSizeMake(SCREEN_WIDTH * images.count, SCREEN_HEIGHT);
}

- (void)goToMain
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:IsSetup];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setRoot];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > (SCREEN_WIDTH * 3 + 30)) {
        [self goToMain];
    }
}



@end
