//
//  PGCSupplyAndDemandCell.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCDemand;

static NSString * const kProcurementCell = @"PGCProcurementCell";

@interface PGCProcurementCell : UITableViewCell

@property (strong, nonatomic) PGCDemand *demand;/** 需求模型 */

@end
