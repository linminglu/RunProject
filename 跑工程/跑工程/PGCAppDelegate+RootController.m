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

@interface PGCAppDelegate () <UIScrollViewDelegate>

@end

@implementation PGCAppDelegate (RootController)


- (void)setRootViewController
{
    if ([PGCUserDefault objectForKey:@"isOne"]) {//不是第一次安装
        // 设置广告页
        [self createAdvertiseView];
        
    } else {
        self.window.rootViewController = [[UIViewController alloc] init];
        // 设置引导页
        [self createLoadingScrollView];
    }
}

// 设置根控制器
- (void)setRoot
{
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.window.rootViewController = [[PGCTabBarController alloc] init];
}

// 初始化 window
- (void)setAppWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
}


#pragma mark - 广告页

- (void)createAdvertiseView
{
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    [XHLaunchAd showWithAdFrame:self.window.bounds setAdImage:^(XHLaunchAd *launchAd) {
        launchAd.noDataDuration = 3;
        
        [PGCOtherAPIManager getLatestAppSplashImageRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                
                LunchImage *model = [[LunchImage alloc] init];
                [model mj_setKeyValues:resultData];
                
                NSString *imageUrl = [kBaseImageURL stringByAppendingString:model.image];
                //定义一个weakLaunchAd
                __weak __typeof(launchAd) weakLaunchAd = launchAd;
                [launchAd setImageUrl:imageUrl duration:3 skipType:SkipTypeTimeText options:XHWebImageRefreshCached completed:^(UIImage *image, NSURL *url) {
                    weakLaunchAd.adFrame = self.window.bounds;
                    
                } click:^{
                    // 广告点击事件
                    PGCWebViewController *webVC = [[PGCWebViewController alloc] init];
                    webVC.urlString = imageUrl;
                    [weakLaunchAd presentViewController:webVC animated:true completion:nil];
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
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        img.image = [UIImage imageNamed:images[i]];
        [sc addSubview:img];
        img.userInteractionEnabled = true;
        
        if (i == images.count - 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake((SCREEN_WIDTH / 2) - 50, SCREEN_HEIGHT - 100, SCREEN_WIDTH * 0.8, 40);
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
    [PGCUserDefault setObject:@"isOne" forKey:@"isOne"];
    [PGCUserDefault synchronize];
    [self setRoot];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > SCREEN_WIDTH * 3 + 30) {
        [self goToMain];
    }
}



@end
