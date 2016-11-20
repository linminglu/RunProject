//
//  SupplyDetailTopCell.h
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCSupply;

static NSString * const kSupplyDetailTopCell = @"SupplyDetailTopCell";

@interface SupplyDetailTopCell : UITableViewCell

@property (strong, nonatomic) PGCSupply *topSupply;/** 供应详情模型 */

@end
