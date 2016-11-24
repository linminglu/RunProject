//
//  PGCVIPServiceCell.h
//  跑工程
//
//  Created by leco on 2016/11/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCVIPServiceCell, PGCProduct;

@protocol PGCVIPServiceCellDelegate <NSObject>

- (void)vipServiceCell:(PGCVIPServiceCell *)cell payButton:(UIButton *)payButton;

@end

static NSString * const kVIPServiceCell = @"VIPServiceCell";

@interface PGCVIPServiceCell : UITableViewCell

@property (weak, nonatomic) id <PGCVIPServiceCellDelegate> delegate;

@property (strong, nonatomic) PGCProduct *product;/** 产品模型 */

@end
