//
//  PGCTabBarController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCTabBarController.h"
#import "PGCTabBar.h"
#import "PGCTabBarButton.h"
#import "PGCNavigationController.h"
#import "UIImage+Image.h"
// rootViewController
#import "PGCProjectInfoController.h"
#import "PGCSupplyAndDemandController.h"
#import "PGCContactsController.h"
#import "PGCProfileController.h"

@interface PGCTabBarController ()<PGCTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (strong, nonatomic) PGCTabBar *pGCTabBar;

@property (assign, nonatomic) BOOL isSelect;

@end

@implementation PGCTabBarController

- (NSMutableArray *)items {
    if (!_items) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setUpAllChildViewController];
    
    // 自定义tabBar
    [self setUpTabBar];
    
    // 每隔一段时间请求未读数
    
}


#pragma mark - 设置tabBar

- (void)setUpTabBar {
    // 自定义tabBar
    self.pGCTabBar = [[PGCTabBar alloc] initWithFrame:self.tabBar.frame];
    self.pGCTabBar.backgroundColor = [UIColor whiteColor];
    
    // 设置代理
    self.pGCTabBar.delegate = self;
    
    // 给tabBar传递tabBarItem模型
    self.pGCTabBar.items = self.items;
    
    // 添加自定义tabBar
    [self.view addSubview:self.pGCTabBar];
    
    // 移除系统的tabBar
    [self.tabBar removeFromSuperview];
    
}



#pragma mark - 当点击tabBar上的按钮调用

- (void)tabBar:(PGCTabBar *)tabBar didClickButton:(NSInteger)index {
    _isSelect = NO;
    self.selectedIndex = index;
    
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    if (_isSelect) {
        self.pGCTabBar.selectIndex = selectedIndex;
    }
    _isSelect = YES;
}

// 点击加号按钮的时候调用


// 设置tabbar的隐藏属性
- (void)setTabBarHidden:(BOOL)hidden {
    self.pGCTabBar.hidden = hidden;
}


#pragma mark - 添加所有的子控制器

- (void)setUpAllChildViewController {
    // 工程信息
    PGCProjectInfoController *projectInfoController = [[PGCProjectInfoController alloc] init];
    [self setUpOneChildViewController:projectInfoController image:[UIImage imageNamed:@"项目nor"] selectedImage:[UIImage imageWithOriginalName:@"项目down"] title:@"工程信息"];
    
    // 供与需
    PGCSupplyAndDemandController *supplyAndDemandController = [[PGCSupplyAndDemandController alloc] init];
    [self setUpOneChildViewController:supplyAndDemandController image:[UIImage imageNamed:@"找供需nor"] selectedImage:[UIImage imageWithOriginalName:@"找供需down"] title:@"找供需"];
    
    // 联系人
    PGCContactsController *contactsController = [[PGCContactsController alloc] init];
    [self setUpOneChildViewController:contactsController image:[UIImage imageNamed:@"通讯录nor"] selectedImage:[UIImage imageWithOriginalName:@"通讯录down"] title:@"通讯录"];
    
    // 我
    PGCProfileController *profileController = [[PGCProfileController alloc] init];
    [self setUpOneChildViewController:profileController image:[UIImage imageNamed:@"我nor"] selectedImage:[UIImage imageWithOriginalName:@"我down"] title:@"我"];
}

// navigationItem决定导航条上的内容
// 导航条上的内容由栈顶控制器的navigationItem决定

#pragma mark - 添加一个子控制器

- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    vc.tabBarItem.badgeValue = @"";
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    
    PGCNavigationController *nav = [[PGCNavigationController alloc] initWithRootViewController:vc];
    // 设置导航条的按钮
    nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self addChildViewController:nav];
}




@end
