//
//  PGCAlertView.h
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PGCAlertViewBlock)(void);

@interface PGCAlertView : UIView

@property (copy, nonatomic) PGCAlertViewBlock block;

- (instancetype)initWithTitle:(NSString *)title;

- (void)showAlertView;

- (void)showAlertViewWithBlock:(PGCAlertViewBlock)block;

@end
