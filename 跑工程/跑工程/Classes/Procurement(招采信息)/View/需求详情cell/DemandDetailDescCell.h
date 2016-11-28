//
//  DemandDetailDescCell.h
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCDemand, PGCSupply;

static NSString * const kDemandDetailDescCell = @"DemandDetailDescCell";

@interface DemandDetailDescCell : UITableViewCell

@property (strong, nonatomic) PGCDemand *demandDesc;/** 招标采购详细介绍 */
@property (strong, nonatomic) PGCSupply *supplyDesc;/** 供应信息详细介绍 */

@end
