//
//  PGCSupplyAndDemandDetailVC.h
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCSupplyAndDemandDetailVC : UIViewController
/**
 需求和供应详情界面标题
 */
@property (copy, nonatomic) NSString *detailVCTitle;

/**
 需求和供应的模型
 */
@property (strong, nonatomic) id detailModel;

@end
