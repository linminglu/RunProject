//
//  PGCIntroduceAddContactCell.h
//  跑工程
//
//  Created by leco on 2016/11/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kIntroduceAddContactCell = @"IntroduceAddContactCell";

@interface PGCIntroduceAddContactCell : UITableViewCell

- (void)addContactTarget:(id)target action:(SEL)action;

@end
