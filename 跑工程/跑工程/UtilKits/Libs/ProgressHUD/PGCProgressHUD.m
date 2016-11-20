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


#pragma mark -
#pragma mark - UIAlertController

+ (void)showAlertWithTarget:(id)target
                      title:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    [target presentViewController:alertController animated:true completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:true completion:nil];
    });
}


+ (void)showAlertWithTitle:(NSString *)title
                     block:(void(^)(void))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:true completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

/**
 1.5s 后消息的MBProgressHUD
 
 @param title
 */
+ (void)showProgressHUDWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.label.text = title;
    
    [hud hideAnimated:true afterDelay:1.5f];
}
/**
 1.5s 后消息的MBProgressHUD
 
 @param view
 @param title
 */
+ (void)showProgressHUDWith:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.label.text = title;
    
    [hud hideAnimated:true afterDelay:1.5f];
}
/**
 1.5s 后消息的MBProgressHUD
 
 @param view
 @param title
 @param block
 */
+ (void)showProgressHUDWith:(UIView *)view title:(NSString *)title block:(void(^)(void))block {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:true];
        block();
    });
}


+ (MBProgressHUD *)showProgressHUD:(UIView *)view label:(NSString *)label {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:true];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.label.text = label;
    return progressHUD;
}



+(void)show:(NSString *)msg toView:(UIView *)view mode:(ProgressMode)myMode{
    [self show:msg toView:view mode:myMode customImgView:nil];
}

+(void)show:(NSString *)msg toView:(UIView *)view mode:(ProgressMode)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    if ([PGCProgressHUD shareinstance].hud != nil) {
        [[PGCProgressHUD shareinstance].hud hideAnimated:true];
        [PGCProgressHUD shareinstance].hud = nil;
    }
    
    [PGCProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    
    [PGCProgressHUD shareinstance].hud.contentColor = [UIColor blackColor];
    
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


+(void)showMessage:(NSString *)msg toView:(UIView *)view{
    [self show:msg toView:view mode:ProgressModeOnlyText];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.5];
}



+(void)showMessage:(NSString *)msg toView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg toView:view mode:ProgressModeOnlyText];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg toView:(UIView *)view{
    [self show:msg toView:view mode:ProgressModeSuccess];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.5];
    
}


+(void)showProgress:(NSString *)msg toView:(UIView *)view{
    [self show:msg toView:view mode:ProgressModeLoading];
}

+(MBProgressHUD *)showProgressCircle:(NSString *)msg toView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = msg;
    return hud;
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg toView:view mode:ProgressModeOnlyText];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.5];
}

@end
