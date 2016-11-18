//
//  PGCAddContactTableCell.h
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCAddContactTableCell;

@protocol PGCAddContactTableCellDelegate <NSObject>

@optional
- (void)addContactTableCell:(PGCAddContactTableCell *)cell textField:(UITextField *)textField;

@end

static NSString *const kAddContactTableCell = @"AddContactTableCell";

@interface PGCAddContactTableCell : UITableViewCell

@property (weak, nonatomic) id <PGCAddContactTableCellDelegate> delegate;
@property (strong, nonatomic) UILabel *addContactTitle;/** 标题 */
@property (strong, nonatomic) UITextField *addContactTF;/** 文本输入框 */

@end
