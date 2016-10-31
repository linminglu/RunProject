//
//  CustomAlertView.h
//  GraduationProject
//
//  Created by Chrissy on 16/3/30.
//  Copyright © 2016年 Liushengtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

/**
 *  弹出视图
 *
 *  @param title      标题
 *  @param content    内容
 *  @param leftTitle  左边按钮标题
 *  @param rigthTitle 右边按钮标题
 */
- (instancetype)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
