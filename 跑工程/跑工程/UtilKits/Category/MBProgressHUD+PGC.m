//
//  MBProgressHUD+PGC.m
//  跑工程
//
//  Created by leco on 2016/11/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MBProgressHUD+PGC.h"

@implementation MBProgressHUD (PGC)


#pragma mark - 显示信息

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (!view) view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    // 设置提示文字
    hud.label.text = text;
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = true;
    
    // 1.0秒之后再消失
    [hud hideAnimated:true afterDelay:1.0];
}


#pragma mark - 显示错误信息

+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showError:(NSString *)error complete:(void (^)(void))complete
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:true];
    hud.label.text = error;
    
    UIImage *image = [UIImage imageNamed:@"MBProgressHUD.bundle/error.png"];
    
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.removeFromSuperViewOnHide = true;
    
    [hud hideAnimated:true afterDelay:1.5];
    
    complete();
}

#pragma mark - 显示正确信息

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}


#pragma mark 显示加载信息

+ (void)showLoading:(NSString *)loading toView:(UIView *)view
{
    if (!view) view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:false];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = true;
    
    // 设置加载时MBProgressHUD不能与用户交互
    hud.userInteractionEnabled = false;
}

@end
