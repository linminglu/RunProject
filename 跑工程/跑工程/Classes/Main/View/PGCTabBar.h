//
//  PGCTabBar.h
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCTabBar, PGCTabBarButton;

@protocol PGCTabBarDelegate <NSObject>

@optional
- (void)tabBar:(PGCTabBar *)tabBar didClickButton:(NSInteger)index;

@end

@interface PGCTabBar : UIView

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<PGCTabBarDelegate> delegate;

@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic, assign) NSInteger selectIndex;


@end
