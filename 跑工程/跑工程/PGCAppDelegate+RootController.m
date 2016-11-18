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

@interface PGCAppDelegate () <UIScrollViewDelegate>

@end

@implementation PGCAppDelegate (RootController)

- (void)setRootViewController
{
    if ([PGCUserDefault objectForKey:@"isOne"])
    {//不是第一次安装
        [self setRoot];
    }
    else
    {
        UIViewController *emptyView = [[UIViewController alloc] init];
        self.window.rootViewController = emptyView;
        [self createLoadingScrollView];
    }
}


- (void)setRoot
{
    self.window.rootViewController = [[PGCTabBarController alloc] init];
}



- (void)setAppWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - 引导页

- (void)createLoadingScrollView
{//引导页
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    sc.pagingEnabled = true;
    sc.delegate = self;
    sc.showsHorizontalScrollIndicator = false;
    sc.showsVerticalScrollIndicator = false;
    [self.window.rootViewController.view addSubview:sc];
    
    NSArray *images;
    
    NSLog(@"%f", SCREEN_WIDTH);
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
    for (NSInteger i = 0; i < images.count; i++)
    {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        img.image = [UIImage imageNamed:images[i]];
        [sc addSubview:img];
        img.userInteractionEnabled = true;
        if (i == images.count - 1)
        {
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
    if (scrollView.contentOffset.x > SCREEN_WIDTH * 3 + 30)
    {
        [self goToMain];
    }
}



@end
