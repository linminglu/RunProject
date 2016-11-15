//
//  PGCContactsCell.h
//  跑工程
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCContact;

static NSString * const kContactsCell = @"ContactsCell";

@interface PGCContactsCell : UITableViewCell

@property (strong, nonatomic) PGCContact *contact;/** 联系人模型 */

@end
