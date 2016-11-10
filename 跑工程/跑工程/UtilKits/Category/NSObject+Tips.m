//
//  NSObject+Tips.m
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "NSObject+Tips.h"

__weak MBProgressHUD * _sharedHud;


#pragma mark -
#pragma mark - UIView

@implementation UIView (Tips)

- (MBProgressHUD *)showTips:(NSString *)message autoHide:(BOOL)autoHide
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hideAnimated:false];
        }
        
        UIView * view = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        _sharedHud = hud;
        
        if ( autoHide )
        {
            [hud hideAnimated:true afterDelay:2.0f];
        }
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hideAnimated:false];
        }
        
        UIView * view = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        hud.yOffset -= 50;
        _sharedHud = hud;
        
        if ( autoHide )
        {
            [hud hideAnimated:true afterDelay:2.0f];
        }
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)showMessageTips:(NSString *)message
{
    return [self showTips:message autoHide:true];
}

- (MBProgressHUD *)showSuccessTips:(NSString *)message
{
    return [self showUpImageSuccessTips:message];
}

- (MBProgressHUD *)showFailureTips:(NSString *)message
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hideAnimated:false];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:true];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_close"]];
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        _sharedHud = hud;
        
        [hud hideAnimated:true afterDelay:2.0f];
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)showFailureTipsWithYOffset:(NSString *)message
{
    return [self showTipsWithYOffset:message autoHide:true];
}

- (MBProgressHUD *)showLoadingTips:(NSString *)message
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hideAnimated:false];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:true];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        
        hud.square = true;
        
        _sharedHud = hud;
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)showUpImageSuccessTips:(NSString *)message
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hideAnimated:false];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:true];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_ok"]];
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        _sharedHud = hud;
        
        hud.yOffset = -SCREEN_WIDTH*0.1;
        hud.square = true;
        
        [hud hideAnimated:true afterDelay:2.f];
    }
    
    return _sharedHud;
}


- (void)dismissTips
{
    [_sharedHud hideAnimated:true];
    _sharedHud = nil;
}

@end


#pragma mark -
#pragma mark - UIViewController

@implementation UIViewController (Tips)

- (MBProgressHUD *)showMessageTips:(NSString *)message
{
    return [self.view showTips:message autoHide:true];
}

- (MBProgressHUD *)showSuccessTips:(NSString *)message
{
    return [self.view showUpImageSuccessTips:message];
}

- (MBProgressHUD *)showFailureTips:(NSString *)message
{
    return [self.view showFailureTips:message];
}

- (MBProgressHUD *)showFailureTipsWithYOffset:(NSString *)message
{
    return [self.view showTipsWithYOffset:message autoHide:true];
}

- (MBProgressHUD *)showLoadingTips:(NSString *)message
{
    return [self.view showLoadingTips:message];
}

- (MBProgressHUD *)showUpImageSuccessTips:(NSString *)message
{
    return [self.view showUpImageSuccessTips:message];
}

- (void)dismissTips
{
    [self.view dismissTips];
}

@end

