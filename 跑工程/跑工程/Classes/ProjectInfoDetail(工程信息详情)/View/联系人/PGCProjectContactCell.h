//
//  PGCProjectContactCell.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProjectContactCell, PGCProjectContact;

@protocol PGCProjectContactCellDelegate <NSObject>

@optional
/**
 点击手机的协议方法

 @param projectContactCell
 @param phone
 */
- (void)projectContactCell:(PGCProjectContactCell *)projectContactCell
                     phone:(id)phone;
/**
 点击地址的协议方法

 @param projectContactCell
 @param address
 */
- (void)projectContactCell:(PGCProjectContactCell *)projectContactCell
                   address:(id)address;

@end

static NSString * const kProjectContactCell = @"ProjectContactCell";

@interface PGCProjectContactCell : UITableViewCell

@property (weak, nonatomic) id <PGCProjectContactCellDelegate> delegate;
@property (strong, nonatomic) PGCProjectContact *projectContact;/** 项目联系人 */

@end
