//
//  PGCProgressHUD.m
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProgressHUD.h"

@implementation PGCProgressHUD

static PGCProgressHUD *instance = nil;

+(instancetype)shareinstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PGCProgressHUD alloc] init];
    });
    return instance;
}


/**
 *  弹出框提示
 *
 *  @param title 提示语句
 */
+ (void)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alertController animated:true completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:true completion:nil];
    });
}

+ (void)showAlertWithTitle:(NSString *)title
                     block:(void(^)(void))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:true completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:true completion:nil];
        block();
    });
}

/**
 *  弹出框
 *
 *  @param target     调用UIAlertController的对象
 *  @param title      弹出框标题
 *  @param message    提示语句
 *  @param otherTitle 弹出框按钮标题
 *  @param handler    弹出框按钮的事件
 */
+ (void)showAlertWithTarget:(id)target title:(NSString *)title
                    message:(NSString *)message
            actionWithTitle:(NSString *)otherTitle
                    handler:(void(^)(void))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    [target presentViewController:alertController animated:true completion:nil];
}

/**
 *  MBProgressHUD
 */
+ (void)showProgressHUDWith:(UIView *)view title:(NSString *)title block:(void(^)(void))block {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:true];
        block();
    });
}

+ (void)showProgressHUDWith:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.label.text = title;
    
    [hud hideAnimated:true afterDelay:1.5f];
}

+ (void)showProgressHUDWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.label.text = title;
    
    [hud hideAnimated:true afterDelay:1.5f];
}

+ (MBProgressHUD *)showProgressHUD:(UIView *)view label:(NSString *)label {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:true];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.label.text = label;
    return progressHUD;
}


+(void)show:(NSString *)msg inView:(UIView *)view mode:(ProgressMode)myMode{
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(ProgressMode)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    if ([PGCProgressHUD shareinstance].hud != nil) {
        [[PGCProgressHUD shareinstance].hud hideAnimated:true];
        [PGCProgressHUD shareinstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:true];
    }
    
    [PGCProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    [PGCProgressHUD shareinstance].hud.dimBackground = true;//是否显示透明背景
    //是否设置黑色背景，这两句配合使用
    [PGCProgressHUD shareinstance].hud.color = [UIColor blackColor];
    [PGCProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];
    
    [[PGCProgressHUD shareinstance].hud setMargin:10];
    [[PGCProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:true];
    [PGCProgressHUD shareinstance].hud.detailsLabel.text = msg;
    
    [PGCProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    switch (myMode) {
        case ProgressModeOnlyText:
            [PGCProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;
            
        case ProgressModeLoading:
            [PGCProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
        case ProgressModeCircleLoading:
            [PGCProgressHUD shareinstance].hud.mode = MBProgressHUDModeDeterminate;
            break;        
        case ProgressModeSuccess:
            [PGCProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [PGCProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
            
        default:
            break;
    }
}


+(void)hide{
    if ([PGCProgressHUD shareinstance].hud != nil) {
        [[PGCProgressHUD shareinstance].hud hideAnimated:true];
    }
}


+(void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ProgressModeOnlyText];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.5];
}



+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:ProgressModeOnlyText];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ProgressModeSuccess];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.5];
    
}


+(void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ProgressModeLoading];
}

+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = msg;
    return hud;
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:ProgressModeOnlyText];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.5];
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:ProgressModeCustomAnimation customImgView:showImageView];
    
    //这句话是为了展示几秒，实际要去掉
//    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:8.0];
}

@end
