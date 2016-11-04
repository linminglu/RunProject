//
//  PGCSupplyAndDemandDetailVC.h
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCSupplyAndDemandShareView.h"

@interface PGCSupplyAndDemandDetailVC : UIViewController <PGCSupplyAndDemandShareViewDelegate>

/**
 弹出框

 @param view
 @param title
 */
- (void)showDetailHUDWith:(UIView *)view title:(NSString *)title;

@end
