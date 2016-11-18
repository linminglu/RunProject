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
#import "PGCProjectInfoController.h"
#import "PGCSupplyAndDemandController.h"
#import "PGCContactsController.h"
#import "PGCProfileController.h"
// APIManager
#import "PGCAreaAPIManager.h"
#import "PGCProjectInfoAPIManager.h"
#import "PGCSupplyAndDemandAPIManager.h"
// Model
#import "PGCProvince.h"
#import "PGCProjectType.h"
#import "PGCProjectProgress.h"
#import "PGCMaterialServiceTypes.h"

@interface PGCTabBarController () <PGCTabBarDelegate>

@property (strong, nonatomic) PGCTabBar *pGCTabBar;
@property (nonatomic, strong) NSMutableArray *items;
@property (assign, nonatomic) BOOL isSelect;

@end

@implementation PGCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setUpAllChildViewController];
    
    // 自定义tabBar
    [self setUpTabBar];
    
    // 网络请求通用数据
    [self initAreaData];
    [self initProjectTypeData];
    [self initProjectStageData];
    [self initMaterialServiceTypesData];
    
    // 每隔一段时间请求未读数
}


#pragma mark - 获取公共数据

/**
 网络请求地区数据
 */
- (void)initAreaData
{
    [PGCAreaAPIManager getCitiesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *cities) {
        if (status == RespondsStatusSuccess) {
            [PGCAreaAPIManager getProvincesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, id provinceData) {
                if (status == RespondsStatusSuccess) {
                    NSMutableArray *results = [NSMutableArray array];
                    
                    for (id value in provinceData) {
                        // 构造省份可变数组
                        NSMutableDictionary *provinceDic = [value mutableCopy];
                        // 用于存储同一省份下的城市数组
                        NSMutableArray *cityData = [NSMutableArray array];
                        
                        for (PGCCity *city in cities) {
                            if (city.province_id == [value[@"id"] intValue]) {
                                [cityData addObject:city];
                            }
                        }
                        // 将城市数组添加到省份字典中
                        [provinceDic setObject:cityData forKey:@"city"];
                        
                        PGCProvince *province = [[PGCProvince alloc] init];
                        [province mj_setKeyValues:provinceDic];
                        // 将模型添加到数组中
                        [results addObject:province];
                    }
                    [PGCProvince province].areaArray = results;
                }
            }];
        }
    }];
}
/**
 网路请求项目类型数据
 */
- (void)initProjectTypeData
{
    [PGCProjectInfoAPIManager getProjectTypesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        if (status == RespondsStatusSuccess) {
            [PGCProjectType projectType].projectTypes = resultData;
        }
    }];
}
/**
 网络请求项目阶段数据
 */
- (void)initProjectStageData
{
    [PGCProjectInfoAPIManager getProjectProgressesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, NSMutableArray *resultData) {
        if (status == RespondsStatusSuccess) {            
            [PGCProjectProgress projectProgress].progressArray = resultData;
        }
    }];
}
/**
 网网络请求供需类别数据
 */
- (void)initMaterialServiceTypesData
{
    [PGCSupplyAndDemandAPIManager getMaterialServiceTypesWithParameters:@{} responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status == RespondsStatusSuccess) {
            NSMutableArray *typeArr = [NSMutableArray array];
            for (id value in resultData) {
                // 构造一级类别模型
                PGCMaterialServiceTypes *type = [[PGCMaterialServiceTypes alloc] init];
                [type mj_setKeyValues:value];
                // 将一级类别模型添加到数组中
                [typeArr addObject:type];
                
                NSMutableArray *seconds = [NSMutableArray array];
                [PGCSupplyAndDemandAPIManager getMaterialServiceTypesWithParameters:@{@"parent_id":@(type.id)} responds:^(RespondsStatus status, NSString *message, id secondResultData) {
                    if (status == RespondsStatusSuccess) {
                        
                        for (id second in secondResultData) {
                            // 构造二级类别模型
                            PGCMaterialServiceTypes *secondType = [[PGCMaterialServiceTypes alloc] init];
                            [secondType mj_setKeyValues:second];
                            // 将二级类别模型添加到数组中
                            [seconds addObject:secondType];
                        }
                    }
                }];
                for (PGCMaterialServiceTypes *value in seconds) {
                    if (value.parent_id == type.id) {
                        [type.secondArray addObject:value];
                    }
                }
            }
            [PGCMaterialServiceTypes materialServiceTypes].typeArray = typeArr;
        }
    }];
}



#pragma mark - 设置tabBar

- (void)setUpTabBar
{
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

- (void)tabBar:(PGCTabBar *)tabBar didClickButton:(NSInteger)index
{
    _isSelect = false;
    self.selectedIndex = index;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    if (_isSelect) {
        self.pGCTabBar.selectIndex = selectedIndex;
    }
    _isSelect = true;
}

// 点击加号按钮的时候调用


// 设置tabbar的隐藏属性
- (void)setTabBarHidden:(BOOL)hidden {
    self.pGCTabBar.hidden = hidden;
}


#pragma mark - 添加所有的子控制器

- (void)setUpAllChildViewController
{
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

- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{    
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


#pragma mark - Getter

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}


@end
