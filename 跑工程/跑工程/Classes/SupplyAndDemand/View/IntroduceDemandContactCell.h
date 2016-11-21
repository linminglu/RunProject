//
//  IntroduceDemandContactCell.h
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Contacts, IntroduceDemandContactCell;

@protocol IntroduceDemandContactCellDelegate <NSObject>

- (void)introduceDemandContactCell:(IntroduceDemandContactCell *)cell deleteBtn:(UIButton *)deleteBtn;

@end

static NSString * const kIntroduceDemandContactCell = @"IntroduceDemandContactCell";

@interface IntroduceDemandContactCell : UITableViewCell

@property (weak, nonatomic) id <IntroduceDemandContactCellDelegate> delegate;
@property (strong, nonatomic) Contacts *contact;/** 联系人 */

@end
