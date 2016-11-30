//
//  DropDownMenu.h
//  跑工程
//
//  Created by leco on 2016/11/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger item;
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;
// default item = -1
+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row item:(NSInteger)item;
@end

@interface BackgroundCellView : UIView

@end

#pragma mark - data source protocol
@class DropDownMenu;

@protocol DropDownMenuDataSource <NSObject>

@required
/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column;
/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DropDownMenu *)menu titleForRowAtIndexPath:(IndexPath *)indexPath;

@optional
/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(DropDownMenu *)menu;
/** 新增
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menu:(DropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column;
/** 新增
 *  当有column列 row 行 item项 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)menu:(DropDownMenu *)menu titleForItemsInRowAtIndexPath:(IndexPath *)indexPath;
/**
 * 新增: 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;



// 新增 返回 menu 第column列 每行image
- (NSString *)menu:(DropDownMenu *)menu imageNameForRowAtIndexPath:(IndexPath *)indexPath;

// 新增 detailText ,right text
- (NSString *)menu:(DropDownMenu *)menu detailTextForRowAtIndexPath:(IndexPath *)indexPath;

// 新增 当有column列 row 行 item项 image
- (NSString *)menu:(DropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(IndexPath *)indexPath;

// 新增 当有column列 row 行 item项 image
- (NSString *)menu:(DropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(IndexPath *)indexPath;

@end

#pragma mark - delegate
@protocol DropDownMenuDelegate <NSObject>

@optional
/**
 *  点击代理，点击了第column 第row 或者item项，如果 item >=0
 */
- (void)menu:(DropDownMenu *)menu didSelectRowAtIndexPath:(IndexPath *)indexPath;
/** 新增
 *  return nil if you don't want to user select specified indexpath
 *  optional
 */
- (NSIndexPath *)menu:(DropDownMenu *)menu willSelectRowAtIndexPath:(IndexPath *)indexPath;

@end

#pragma mark - interface
@interface DropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id <DropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <DropDownMenuDelegate> delegate;

@property (nonatomic, assign) UITableViewCellStyle cellStyle;   // default value1
@property (nonatomic, strong) UIColor *indicatorColor;          // 三角指示器颜色
@property (nonatomic, strong) UIColor *textColor;               // 文字title颜色
@property (nonatomic, strong) UIColor *textSelectedColor;       // 文字title选中颜色
@property (nonatomic, strong) UIColor *detailTextColor;         // detailText文字颜色
@property (nonatomic, strong) UIFont *detailTextFont;           // font
@property (nonatomic, strong) UIColor *separatorColor;          // 分割线颜色
@property (nonatomic, assign) NSInteger fontSize;               // 字体大小

@property (nonatomic, assign) BOOL isClickHaveItemValid;// 当有二级列表item时，点击row 是否调用点击代理方法

@property (nonatomic, getter=isRemainMenuTitle) BOOL remainMenuTitle; // 切换条件时是否更改menu title
@property (nonatomic, strong) NSMutableArray  *currentSelectRowArray; // 恢复默认选项用
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

// 获取title
- (NSString *)titleForRowAtIndexPath:(IndexPath *)indexPath;

// 重新加载数据
- (void)reloadData;

// 创建menu 第一次显示 不会调用点击代理，这个手动调用
- (void)selectDefalutIndexPath;

- (void)selectIndexPath:(IndexPath *)indexPath; // 默认trigger delegate

- (void)selectIndexPath:(IndexPath *)indexPath triggerDelegate:(BOOL)trigger; // 调用代理

@end
