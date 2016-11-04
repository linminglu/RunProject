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


@protocol PGCDropMenuDataSource <NSObject>

@required

/**
 leftOrRight = -1 时，设置collectView的number
 leftOrRight = 0 时， 设置centerTable的number
 leftOrRight = 1 时， 设置leftTable的number
 leftOrRight = 2 时， 设置rightTable的number
 */
- (NSInteger)dropMenu:(PGCDropMenu *)dropMenu
 numberOfRowsInColumn:(NSInteger)column
          leftOrRight:(NSInteger)leftOrRight
      leftSelectedRow:(NSInteger)leftSelectedRow;

- (NSString *)dropMenu:(PGCDropMenu *)dropMenu titleForRowAtIndexPath:(PGCIndexPath *)indexPath;

/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightInColumn:(NSInteger)column;
/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayCollectionViewInColumn:(NSInteger)column;

@end


@protocol PGCDropMenuDelegate <NSObject>

@optional
- (void)dropMenu:(PGCDropMenu *)dropMenu didSelectRowAtIndexPath:(PGCIndexPath *)indexPath;

@end


@interface PGCDropMenu : UIView

@property (weak, nonatomic) id <PGCDropMenuDataSource> dataSource;
@property (weak, nonatomic) id <PGCDropMenuDelegate> delegate;

/**
 按钮标题数组
 */
@property (copy, nonatomic) NSArray *dropTitles;
/**
 初始化方法

 @param origin 坐标
 @param height 高度
 @return
 */
- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height;

@end
