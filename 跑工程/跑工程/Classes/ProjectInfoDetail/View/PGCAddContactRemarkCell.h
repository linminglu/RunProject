//
//  PGCAddContactRemarkCell.h
//  跑工程
//
//  Created by leco on 2016/11/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCAddContactRemarkCell;

@protocol PGCAddContactRemarkCellDelegate <NSObject>

@optional
- (void)addContactRemarkCell:(PGCAddContactRemarkCell *)cell textView:(UITextView *)textView;

@end

static NSString *const kAddContactRemarkCell = @"AddContactRemarkCell";

@interface PGCAddContactRemarkCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) id <PGCAddContactRemarkCellDelegate> delegate;
@property (strong, nonatomic) UITextView *addRemarkTextView;/** 文本视图 */

@end
