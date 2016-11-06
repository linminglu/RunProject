//
//  PGCDetailContactCell.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *const kPGCDetailContactCell = @"PGCDetailContactCell";

@interface PGCDetailContactCell : UITableViewCell

@property (copy, nonatomic) NSDictionary *contactDic;

- (void)addTarget:(id)target action:(SEL)action;

@end
