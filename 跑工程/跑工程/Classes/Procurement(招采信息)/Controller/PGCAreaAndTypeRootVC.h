//
//  PGCAreaAndTypeRootVC.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProvince, PGCCity, PGCMaterialServiceTypes;

typedef void(^AreaBlock)(PGCProvince *province, PGCCity *city);
typedef void(^TypeBlock)(NSMutableArray<PGCMaterialServiceTypes *> *types);

@interface PGCAreaAndTypeRootVC : UIViewController

@property (strong, nonatomic) NSMutableArray *dataSource;/** 数据源 */

@property (copy, nonatomic) AreaBlock areaBlock;/** 地区回调block */
@property (copy, nonatomic) TypeBlock typeBlock;/** 类型回调block */

@end
