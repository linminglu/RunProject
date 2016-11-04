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
    
    NSArray *arr = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"];
    
    for (NSInteger i = 0; i < arr.count; i++)
    {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.window.frame.size.height)];
        img.image = [UIImage imageNamed:arr[i]];
        [sc addSubview:img];
        img.userInteractionEnabled = true;
        if (i == arr.count - 1)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake((self.window.frame.size.width / 2) - 50, SCREEN_HEIGHT - 110, 100, 40);
            btn.backgroundColor = RGB(250, 117, 10);
            [btn setTitle:@"开始体验" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = RGB(250, 117, 10).CGColor;
        }
    }
    sc.contentSize = CGSizeMake(SCREEN_WIDTH * arr.count, self.window.frame.size.height);
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
    if (scrollView.contentOffset.x > SCREEN_WIDTH * 4 + 30)
    {
        [self goToMain];
    }
}



@end
