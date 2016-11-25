//
//  PGCDropRightCell.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kPGCDropRightCell = @"PGCDropRightCell";

@interface PGCDropRightCell : UITableViewCell

@property (strong, nonatomic) UILabel *rightTitleLabel;
@property (strong, nonatomic) UIImageView *rightAccessoryView;

@end
