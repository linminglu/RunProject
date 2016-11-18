//
//  PGCDetailContactCell.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Contacts, PGCDetailContactCell;

@protocol PGCDetailContactCellDelegate <NSObject>

- (void)detailContactCell:(PGCDetailContactCell *)cell phone:(UIButton *)phone;

@end

static NSString *const kPGCDetailContactCell = @"PGCDetailContactCell";

@interface PGCDetailContactCell : UITableViewCell

@property (weak, nonatomic) id <PGCDetailContactCellDelegate> delegate;
@property (strong, nonatomic) Contacts *contact;

@end
