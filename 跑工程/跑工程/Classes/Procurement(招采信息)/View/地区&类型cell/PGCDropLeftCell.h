//
//  PGCDropLeftCell.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProvince;

static NSString *const kPGCDropLeftCell = @"PGCDropLeftCell";

@interface PGCDropLeftCell : UITableViewCell

@property (strong, nonatomic) UILabel *leftTitleLabel;

@property (strong, nonatomic) UIImageView *leftAccessoryView;

@end
