//
//  PGCNavigationController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCNavigationController.h"
#import "PGCTabBarController.h"

@interface PGCNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation PGCNavigationController


+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置导航条按钮的文字颜色
    bar.tintColor = PGCTextColor;
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:PGCTextColor};
    bar.translucent = true;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //存储手势代理
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers.firstObject) {//是根控制器
        self.interactivePopGestureRecognizer.delegate = nil;
        [(PGCTabBarController *)self.tabBarController setTabBarHidden:false];
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self.viewControllers.firstObject) {//不是根控制器
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
        [(PGCTabBarController *)self.tabBarController setTabBarHidden:true];
    }
    // 设置导航条的返回按钮
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [super pushViewController:viewController animated:animated];
}




@end
