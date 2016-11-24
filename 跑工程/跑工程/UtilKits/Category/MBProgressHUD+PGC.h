//
//  MBProgressHUD+PGC.h
//  跑工程
//
//  Created by leco on 2016/11/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (PGC)
/** 显示成功信息 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/** 显示失败信息 */
+ (void)showError:(NSString *)error toView:(UIView *)view;
/** 显示加载信息 */
+ (void)showLoading:(NSString *)loading toView:(UIView *)view;

@end
