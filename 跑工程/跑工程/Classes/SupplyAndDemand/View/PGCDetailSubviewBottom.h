//
//  PGCDetailSubview2.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCDetailSubviewBottom : UIView

- (instancetype)initWithModel:(id)model;

- (void)addDetailTarget:(id)target action:(SEL)action;

@end
