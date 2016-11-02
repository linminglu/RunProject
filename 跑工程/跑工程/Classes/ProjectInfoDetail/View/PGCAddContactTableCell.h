//
//  PGCAddContactTableCell.h
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kAddContactTableCell = @"AddContactTableCell";
static NSString *const kAddContactRemarkCell = @"AddContactRemarkCell";

@interface PGCAddContactRemarkCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) UILabel *textViewPlaceholder;/** 文本视图占位符 */
@property (strong, nonatomic) UITextView *addRemarkTextView;/** 文本视图 */

@end



@interface PGCAddContactTableCell : UITableViewCell

@property (strong, nonatomic) UILabel *addContactTitle;/** 标题 */
@property (strong, nonatomic) UITextField *addContactTF;/** 文本输入框 */

@end
