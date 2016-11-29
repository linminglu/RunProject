//
//  PGCSupplyInfoCell.h
//  跑工程
//
//  Created by leco on 2016/11/29.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCSupply;

static NSString * const kSupplyInfoCell = @"PGCSupplyInfoCell";

@interface PGCSupplyInfoCell : UITableViewCell

@property (strong, nonatomic) PGCSupply *supply;/** 供应模型 */

@end
