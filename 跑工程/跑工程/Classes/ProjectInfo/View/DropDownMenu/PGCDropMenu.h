//
//  PGCDropMenu.h
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCIndexPath.h"

@class PGCDropMenu;

#pragma mark - DataSource protocol

@protocol PGCDropMenuDataSource <NSObject>

@required
- (NSInteger)menu:(PGCDropMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(PGCDropMenu *)menu titleForRowAtIndexPath:(PGCIndexPath *)indexPath;
- (NSString *)menu:(PGCDropMenu *)menu titleForColumn:(NSInteger)column;

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
/**
 下拉菜单的按钮数量

 @param menu
 @return 
 */
- (NSInteger)numberOfColumnsInMenu:(PGCDropMenu *)menu;
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end


#pragma mark - Delegate protocol

@protocol PGCDropMenuDelegate <NSObject>

@optional
/**
 点击指定行的代理方法

 @param menu
 @param indexPath
 */
- (void)menu:(PGCDropMenu *)menu didSelectRowAtIndexPath:(PGCIndexPath *)indexPath;

@end


@interface PGCDropMenu : UIView
/**
 数据源
 */
@property (nonatomic, weak) id <PGCDropMenuDataSource> dataSource;
/**
 代理
 */
@property (nonatomic, weak) id <PGCDropMenuDelegate> delegate;

/**
 指示器颜色
 */
@property (nonatomic, strong) UIColor *indicatorColor;
/**
 标题文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 初始化方法

 @param origin 坐标
 @param height 高度
 @return
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
/**
 titleForRow

 @param indexPath
 @return
 */
- (NSString *)titleForRowAtIndexPath:(PGCIndexPath *)indexPath;

@end
