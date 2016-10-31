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
- (void)projectInfoNavigationBar:(PGCProjectInfoNavigationBar *)PGCProjectInfoNavigationBar tapItem:(NSInteger)tag;

@end


@interface PGCProjectInfoBarItem : UIButton

// 自定义Item的图片视图
@property (strong, nonatomic) UIImageView *barItemImage;
// 自定义Item的文字标签
@property (strong, nonatomic) UILabel *barItemLabel;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

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
