//
//  PGCTableViewCell.h
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Size.h"

static NSString *const kPGCTableViewCell = @"PGCTableViewCell";

@interface PGCTableViewCell : UITableViewCell

@property(nonatomic,readonly) UILabel *cellTextLabel;

@property(nonatomic,strong) UIImageView *cellAccessoryView;

- (void)setCellText:(NSString *)text align:(NSString*)align;

@end
