//
//  NSObject+Tips.h
//  跑工程
//
//  Created by leco on 2016/11/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>


#pragma mark -
#pragma mark - UIView

/**
 直接在视图上显示提示信息
 */
@interface UIView (Tips)

- (MBProgressHUD *)showMessageTips:(NSString *)message;
- (MBProgressHUD *)showSuccessTips:(NSString *)message;
- (MBProgressHUD *)showFailureTips:(NSString *)message;
- (MBProgressHUD *)showLoadingTips:(NSString *)message;
- (MBProgressHUD *)showFailureTipsWithYOffset:(NSString *)message;
- (MBProgressHUD *)showUpImageSuccessTips:(NSString *)message;

- (void)dismissTips;

@end


#pragma mark -
#pragma mark - UIViewController

@interface UIViewController (Tips)

- (MBProgressHUD *)showMessageTips:(NSString *)message;
- (MBProgressHUD *)showSuccessTips:(NSString *)message;
- (MBProgressHUD *)showFailureTips:(NSString *)message;
- (MBProgressHUD *)showLoadingTips:(NSString *)message;
- (MBProgressHUD *)showFailureTipsWithYOffset:(NSString *)message;
- (MBProgressHUD *)showUpImageSuccessTips:(NSString *)message;
- (void)dismissTips;

@end
