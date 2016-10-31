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

+ (void)initialize {
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {    
    
    PGCTabBarController* tabbarVC = (PGCTabBarController*)self.tabBarController;
    if (viewController == self.viewControllers.firstObject) {//是根控制器
        
        self.interactivePopGestureRecognizer.delegate = nil;
        [tabbarVC setTabBarHidden:false];
        
    } else {
        
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
        [tabbarVC setTabBarHidden:true];
    }
}

//设置非根控制器的导航条的左按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 设置导航条的返回按钮
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [super pushViewController:viewController animated:animated];
}

- (void)popToPre {
    [self popViewControllerAnimated:true];
}

@end
