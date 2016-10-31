//
//  PGCDropDownMenu.h
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCIndexPath.h"

@class PGCDropDownMenu;

#pragma mark - DataSource protocol

@protocol PGCDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(PGCDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(PGCDropDownMenu *)menu titleForRowAtIndexPath:(PGCIndexPath *)indexPath;
- (NSString *)menu:(PGCDropDownMenu *)menu titleForColumn:(NSInteger)column;
/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
//default value is 1
- (NSInteger)numberOfColumnsInMenu:(PGCDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end


#pragma mark - Delegate protocol

@protocol PGCDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(PGCDropDownMenu *)menu didSelectRowAtIndexPath:(PGCIndexPath *)indexPath;

@end


#pragma mark - PGCDropDownMenu

@interface PGCDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <PGCDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <PGCDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

- (NSString *)titleForRowAtIndexPath:(PGCIndexPath *)indexPath;

@end
