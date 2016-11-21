//
//  DemandDetailContactCell.h
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Contacts, DemandDetailContactCell;

@protocol DemandDetailContactCellDelegate <NSObject>

- (void)demandDetailContactCell:(DemandDetailContactCell *)cell phone:(UIButton *)phone;

@end

static NSString * const kDemandDetailContactCell = @"DemandDetailContactCell";

@interface DemandDetailContactCell : UITableViewCell

@property (weak, nonatomic) id <DemandDetailContactCellDelegate> delegate;
@property (strong, nonatomic) Contacts *contact;/** 需求联系人 */

@end
