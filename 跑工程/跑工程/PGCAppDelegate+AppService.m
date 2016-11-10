//
//  PGCAppDelegate+AppService.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAppDelegate+AppService.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
// APIManager
#import "PGCAreaAPIManager.h"
#import "PGCProjectInfoAPIManager.h"
#import "PGCSupplyAndDemandAPIManager.h"
// Model
#import "PGCProvince.h"
#import "PGCProjectType.h"
#import "PGCProjectProgress.h"
#import "PGCMaterialServiceTypes.h"

@implementation PGCAppDelegate (AppService)

- (void)configLaunchingUserData
{
    // 网络请求通用数据
    [self initAreaData];
    [self initProjectTypeData];
    [self initProjectStageData];
    [self initMaterialServiceTypesData];
}

#pragma mark - 获取公共数据

/**
 网络请求地区数据
 */
- (void)initAreaData
{
    [PGCAreaAPIManager getCitiesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, id citiesData) {
        
        if (status == RespondsStatusSuccess) {
            
            NSMutableArray *cities = [NSMutableArray array];
            
            for (id temp in citiesData) {
                PGCCity *city = [PGCCity mj_objectWithKeyValues:temp];
                // 将城市模型添加到数组中
                [cities addObject:city];
            }
            
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
                        
                        PGCProvince *province = [PGCProvince mj_objectWithKeyValues:provinceDic];
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
    [PGCProjectInfoAPIManager getProjectTypesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        if (status == RespondsStatusSuccess) {
            
            NSMutableArray *typeArr = [NSMutableArray array];
            
            for (id value in resultData) {
                PGCProjectType *projectType = [PGCProjectType mj_objectWithKeyValues:value];
                // 将模型添加到数组中
                [typeArr addObject:projectType];
                
            }
            [PGCProjectType projectType].projectTypes = typeArr;
        }
    }];
}
/**
 网络请求项目阶段数据
 */
- (void)initProjectStageData
{
    [PGCProjectInfoAPIManager getProjectProgressesRequestWithParameters:@{} responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        if (status == RespondsStatusSuccess) {
            
            NSMutableArray *progressArr = [NSMutableArray array];
            
            for (id value in resultData) {
                PGCProjectProgress *progress = [PGCProjectProgress mj_objectWithKeyValues:value];
                // 将模型添加到数组中
                [progressArr addObject:progress];
            }
            [PGCProjectProgress projectProgress].progressArray = progressArr;
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
                PGCMaterialServiceTypes *type = [PGCMaterialServiceTypes mj_objectWithKeyValues:value];
                // 将一级类别模型添加到数组中
                [typeArr addObject:type];
                
                __block NSMutableArray *seconds = [NSMutableArray array];
                [PGCSupplyAndDemandAPIManager getMaterialServiceTypesWithParameters:@{@"parent_id":@(type.id)} responds:^(RespondsStatus status, NSString *message, id secondResultData) {
                    if (status == RespondsStatusSuccess) {
                        
                        for (id second in secondResultData) {
                            // 构造二级类别模型
                            PGCMaterialServiceTypes *secondType = [PGCMaterialServiceTypes mj_objectWithKeyValues:second];
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


- (void)registerAMap
{
    [AMapServices sharedServices].apiKey = AMapKey;
}


- (void)checkAppUpDataWithshowOption:(BOOL)showOption
{
    
}


@end
