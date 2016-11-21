//
//  PGCIntroducePublicView.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCIntroducePublicView : UIView

@property (strong, nonatomic) UITextField *contentTF;/** 内容文本输入框 */

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
