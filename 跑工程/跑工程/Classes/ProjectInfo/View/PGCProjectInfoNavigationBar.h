//
//  PGCProjectInfoNavigationBar.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProjectInfoNavigationBar;

@protocol PGCProjectInfoNavigationBarDelegate <NSObject>

@optional
- (void)projectInfoNavigationBar:(PGCProjectInfoNavigationBar *)projectInfoNavigationBar tapItem:(NSInteger)tag;

@end


typedef NS_ENUM(NSUInteger, NavigationItemTag) {
    //导航栏上的按钮的Tag
    mapItemTag,
    recordItemTag,
    collectItemTag,
    searchItemTag
};

@interface PGCProjectInfoNavigationBar : UIView

@property (weak, nonatomic) id <PGCProjectInfoNavigationBarDelegate> delegate;

@end
