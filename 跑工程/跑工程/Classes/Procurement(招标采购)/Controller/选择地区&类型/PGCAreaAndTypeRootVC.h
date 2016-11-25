//
//  PGCAreaAndTypeRootVC.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBlock)(NSString *area);

@interface PGCAreaAndTypeRootVC : UIViewController

@property (strong, nonatomic) NSMutableArray *dataSource;/** 数据源 */
@property (copy, nonatomic) BackBlock block;/** 地区回调block */

@end
