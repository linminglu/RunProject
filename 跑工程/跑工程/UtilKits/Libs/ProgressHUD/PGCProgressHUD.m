//
//  PGCProgressHUD.m
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProgressHUD.h"

@implementation PGCProgressHUD

#pragma mark -
#pragma mark - UIAlertController

+ (void)showAlertWithTarget:(id)target
                      title:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    [target presentViewController:alertController animated:true completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:true completion:nil];
    });
}


+ (void)showAlertWithTitle:(NSString *)title
                     block:(void(^)(void))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:true completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:true completion:nil];
        block();
    });
}


+ (void)showAlertWithTarget:(id)target title:(NSString *)title
                    message:(NSString *)message
            actionWithTitle:(NSString *)otherTitle
                    handler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:handler]];
    [target presentViewController:alert animated:true completion:nil];
}

+ (void)showAlertWithTarget:(id)target
                      title:(NSString *)title
                    message:(NSString *)message
                actionTitle:(NSString *)actionTitle
           otherActionTitle:(NSString *)otherActionTitle
                    handler:(void (^)(UIAlertAction *action))handler
               otherHandler:(void (^)(UIAlertAction *action))otherHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:otherActionTitle style:UIAlertActionStyleDestructive handler:otherHandler]];
    [target presentViewController:alert animated:true completion:nil];
}


#pragma mark -
#pragma mark - MBProgressHUD

static PGCProgressHUD *instance = nil;

+ (instancetype)shareinstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PGCProgressHUD alloc] init];
    });
    return instance;
}

+ (MBProgressHUD *)showProgress:(NSString *)msg toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.label.text = msg;
    hud.label.font = [UIFont boldSystemFontOfSize:16];
    return hud;
}

+ (void)show:(NSString *)msg toView:(UIView *)view mode:(ProgressMode)myMode customImgView:(UIImageView *)customImgView
{
    PGCProgressHUD *instance = [PGCProgressHUD shareinstance];
    
    //如果已有弹框，先消失
    if (instance.hud != nil) {
        [instance.hud hideAnimated:true];
        instance.hud = nil;
    }
    
    instance.hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    instance.hud.contentColor = [UIColor darkGrayColor];
    instance.hud.margin = 10;
    instance.hud.removeFromSuperViewOnHide = true;
    instance.hud.detailsLabel.text = msg;
    instance.hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    
    switch (myMode) {
        case ProgressModeOnlyText:
            instance.hud.mode = MBProgressHUDModeText;
            break;
            
        case ProgressModeLoading:
            instance.hud.mode = MBProgressHUDModeIndeterminate;
            break;
        case ProgressModeCircleLoading:
            instance.hud.mode = MBProgressHUDModeDeterminate;
            break;
        default:
            break;
    }
}

+ (void)hide
{
    PGCProgressHUD *instance = [PGCProgressHUD shareinstance];
    
    if (instance.hud) {
        [instance.hud hideAnimated:true];
    }
}

+ (void)show:(NSString *)msg toView:(UIView *)view mode:(ProgressMode)myMode
{
    [self show:msg toView:view mode:myMode customImgView:nil];
}


+ (void)showMessage:(NSString *)msg toView:(UIView *)view
{
    [self show:msg toView:view mode:ProgressModeOnlyText];
    
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.5];
}

+ (void)showMessage:(NSString *)msg toView:(UIView *)view afterDelayTime:(NSInteger)delay
{
    [self show:msg toView:view mode:ProgressModeOnlyText];
    
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:delay];
}

+ (MBProgressHUD *)showProgressCircle:(NSString *)msg toView:(UIView *)view
{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = msg;
    return hud;
}

@end
