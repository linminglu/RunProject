//
//  PGCContactInfoCell.h
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCContact, PGCContactInfoCell;

@protocol PGCContactInfoCellDelegate <NSObject>

@optional
- (void)contactInfoCell:(PGCContactInfoCell *)contactInfoCell textViewDidBeginEditing:(UITextView *)textView;
- (void)contactInfoCell:(PGCContactInfoCell *)contactInfoCell textViewDidEndEditing:(UITextView *)textView;

@end

static NSString * const kPGCContactInfoCell = @"PGCContactInfoCell";

@interface PGCContactInfoCell : UITableViewCell

@property (weak, nonatomic) id <PGCContactInfoCellDelegate> delegate;
@property (strong, nonatomic) PGCContact *contactLeft;/** 联系人模型 */

@end
