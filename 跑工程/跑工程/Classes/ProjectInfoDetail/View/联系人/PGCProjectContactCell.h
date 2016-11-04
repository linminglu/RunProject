//
//  PGCProjectContactCell.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProjectContactCell;

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

@interface PGCProjectContactCell : UITableViewCell

@property (weak, nonatomic) id <PGCProjectContactCellDelegate> delegate;

@end
