//
//  PGCAddContactTableCell.h
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kAddContactTableCell = @"AddContactTableCell";

@interface PGCAddContactTableCell : UITableViewCell

@property (strong, nonatomic) UILabel *addContactTitle;/** 标题 */
@property (strong, nonatomic) UITextField *addContactTF;/** 文本输入框 */

@end
