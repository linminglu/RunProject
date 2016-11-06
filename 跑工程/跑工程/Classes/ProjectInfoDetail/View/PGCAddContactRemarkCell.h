//
//  PGCAddContactRemarkCell.h
//  跑工程
//
//  Created by leco on 2016/11/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kAddContactRemarkCell = @"AddContactRemarkCell";

@interface PGCAddContactRemarkCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) UILabel *textViewPlaceholder;/** 文本视图占位符 */
@property (strong, nonatomic) UITextView *addRemarkTextView;/** 文本视图 */

@end
