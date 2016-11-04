//
//  PGCDetailContactCell.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCDetailContactCell;

@protocol PGCDetailContactCellDelegate <NSObject>

@optional
- (void)contactCell:(PGCDetailContactCell *)contactCell callBtn:(UIButton *)callBtn;

@end

static NSString *const kPGCDetailContactCell = @"PGCDetailContactCell";

@interface PGCDetailContactCell : UITableViewCell

@property (weak, nonatomic) id <PGCDetailContactCellDelegate> delegate;

@property (copy, nonatomic) NSDictionary *contactDic;

@end
