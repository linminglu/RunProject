//
//  PGCTabBarButton.h
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCBadgeView.h"

@interface PGCTabBarButton : UIButton

@property (nonatomic, strong) UITabBarItem *item;

@property (nonatomic, weak) PGCBadgeView *badgeView;

@end
