//
//  PGCDetailTitleView.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCDetailTitleView : UIView

@property (copy, nonatomic) NSString *content;/** 内容标签 */

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

- (instancetype)initWithTitle:(NSString *)title;

@end
