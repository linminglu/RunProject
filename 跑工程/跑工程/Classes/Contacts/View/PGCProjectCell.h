//
//  PGCProjectCell.h
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCContact;

static NSString * const kPGCProjectCell = @"PGCProjectCell";

@interface PGCProjectCell : UITableViewCell

@property (strong, nonatomic) PGCContact *contactRight;/** 联系人模型 */

@end
