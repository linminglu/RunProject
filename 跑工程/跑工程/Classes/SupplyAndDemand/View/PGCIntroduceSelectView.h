//
//  PGCIntroduceSelectView.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCIntroduceSelectView : UIView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

- (void)addTarget:(id)target action:(SEL)action;

@end
