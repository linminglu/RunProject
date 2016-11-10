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
    //[PGCProgressHUD shareinstance].hud.dimBackground = true;    //是否显示透明背景
    
    //是否设置黑色背景，这两句配合使用
    [PGCProgressHUD shareinstance].hud.backgroundColor = [UIColor blackColor];
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
//        case ProgressModeCircleLoading:{
//            [PGCProgressHUD shareinstance].hud.mode = MBProgressHUDModeDeterminate;
//
//            break;
//        }
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
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.0];
}



+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:ProgressModeOnlyText];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:ProgressModeSuccess];
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.0];
    
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
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:1.0];
    
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:ProgressModeCustomAnimation customImgView:showImageView];
    
    //这句话是为了展示几秒，实际要去掉
    [[PGCProgressHUD shareinstance].hud hideAnimated:true afterDelay:8.0];
}


@end
