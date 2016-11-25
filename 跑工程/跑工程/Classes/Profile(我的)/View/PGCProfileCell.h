//
//  PGCProfileCell.h
//  跑工程
//
//  Created by leco on 2016/11/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCProfileCell : UIView

@property (copy, nonatomic) NSString *titleImageName;/** 标题图片名称 */
@property (copy, nonatomic) NSString *title;/** 标题 */
@property (copy, nonatomic) NSString *detailTitle;/** 子标题 */
@property (assign, nonatomic) BOOL isShow;/** 是否显示子标题 */

- (void)addTarget:(id)target event:(SEL)event;

@end
