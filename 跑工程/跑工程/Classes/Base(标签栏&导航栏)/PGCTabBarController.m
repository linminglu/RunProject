//
//  PGCTabBarController.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCTabBarController.h"
#import "PGCNavigationController.h"

#import "PGCProjectInfoController.h"
#import "PGCSupplyInfoViewController.h"
#import "PGCProcurementViewController.h"
#import "PGCProfileController.h"

#import "PGCSupplyAndDemandAPIManager.h"
#import "PGCMaterialServiceTypes.h"

@interface PGCTabBarController ()

@end

@implementation PGCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setupChildViewControllers];
    // 网络请求通用数据
    [self initMaterialServiceTypesData];
}

#pragma mark - 添加所有的子控制器

- (void)setupChildViewControllers
{
    // 工程信息
    PGCProjectInfoController *projectInfoVC = [[PGCProjectInfoController alloc] init];
    // 招标采购
    PGCProcurementViewController *procurementVC = [[PGCProcurementViewController alloc] init];
    // 供应信息
    PGCSupplyInfoViewController *supplyInfoVC = [[PGCSupplyInfoViewController alloc] init];
    // 我的
    PGCProfileController *profileVC = [[PGCProfileController alloc] init];
    
    NSArray *titles = @[@"工程信息", @"招标采购", @"供应信息", @"我"];
    NSArray *images = @[[UIImage imageNamed:@"项目nor"],
                        [UIImage imageNamed:@"找供需nor"],
                        [UIImage imageNamed:@"找供需nor"],
                        [UIImage imageNamed:@"我nor"]];
    NSArray *selectedImages = @[[UIImage imageWithOriginalName:@"项目down"],
                                [UIImage imageWithOriginalName:@"找供需down"],
                                [UIImage imageWithOriginalName:@"找供需down"] ,
                                [UIImage imageWithOriginalName:@"我down"]];
    NSArray *vcArray = @[projectInfoVC, procurementVC, supplyInfoVC, profileVC];
    NSMutableArray *navArray = [NSMutableArray array];
    
    __weak __typeof(self) weakSelf = self;
    [vcArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull viewController, NSUInteger i, BOOL * _Nonnull stop) {
        
        PGCNavigationController *navigationController = [weakSelf setupRootViewController:viewController title:titles[i] image:images[i] selectedImage:selectedImages[i]];
        [navArray addObject:navigationController];
    }];
    self.viewControllers = navArray;
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = PGCTintColor;
    self.selectedIndex = 0;
}


- (PGCNavigationController *)setupRootViewController:(UIViewController *)viewController
                          title:(NSString *)title
                          image:(UIImage *)image
                  selectedImage:(UIImage *)selectedImage
{    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    viewController.tabBarItem = tabBarItem;
    
    PGCNavigationController *navigationController = [[PGCNavigationController alloc] initWithRootViewController:viewController];
    return navigationController;
}


#pragma mark - 网络请求数据
/**
 网络请求供需类别数据
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


@end
