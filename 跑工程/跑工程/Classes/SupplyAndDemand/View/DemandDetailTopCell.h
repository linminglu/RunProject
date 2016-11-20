//
//  DemandDetailTopCell.h
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCDemand;

static NSString * const kDemandDetailTopCell = @"DemandDetailTopCell";

@interface DemandDetailTopCell : UITableViewCell

@property (strong, nonatomic) PGCDemand *topDemand;/** 需求详情模型 */

@end
