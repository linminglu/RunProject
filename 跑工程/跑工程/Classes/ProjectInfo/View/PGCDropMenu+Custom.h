//
//  PGCDropMenu+Custom.h
//  跑工程
//
//  Created by leco on 2016/11/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropMenu.h"

@interface PGCDropMenu (Custom)
/**
 创建按钮背景layer
 
 @param position
 @return
 */
- (CALayer *)createBgLayerWithPosition:(CGPoint)position;
/**
 创建按钮三角指示器layer
 
 @param color 颜色
 @param point 旋转角度
 @return
 */
- (CAShapeLayer *)createIndicatorWithPosition:(CGPoint)point;
/**
 创建按钮文字layer
 
 @param string
 @param color
 @param point
 @return
 */
- (CATextLayer *)createTextLayerWithString:(NSString *)string
                                  position:(CGPoint)point;
/**
 创建下划分割线

 @param point
 @return
 */
- (CAShapeLayer *)createSeparatorLineWithPosition:(CGPoint)point;


#pragma mark - Animation

/**
 黑色背景的动画

 @param view
 @param show
 @param complete
 */
- (void)showBackgroundView:(UIView *)view
                      show:(BOOL)show
                  complete:(void(^)())complete;
/**
 下拉菜单表格视图的动画

 @param leftTable
 @param rightTable
 @param show
 @param complete
 */
- (void)showLeftTable:(UITableView *)leftTable
           rightTable:(UITableView *)rightTable
                 show:(BOOL)show
             complete:(void(^)())complete;
/**
 中间表格视图的动画
 
 @param centerTable
 @param show
 @param complete
 */
- (void)showCenterTable:(UITableView *)centerTable
                   show:(BOOL)show
               complete:(void(^)())complete;
/**
 下拉菜单集合视图的动画
 
 @param collectionView
 @param show
 @param complete
 */
- (void)showCollectionView:(UICollectionView *)collectionView
                      show:(BOOL)show
                  complete:(void(^)())complete;
/**
 按钮指示器的动画
 
 @param indicator
 @param forward
 @param complete
 */
- (void)showIndicator:(CAShapeLayer *)indicator
              forward:(BOOL)forward
             complete:(void(^)())complete;
/**
 动画显示左右表格视图下拉菜单
 
 @param indicator
 @param background
 @param leftTable
 @param rightTable
 @param forward
 @param complete
 */
- (void)showIndicator:(CAShapeLayer *)indicator
           background:(UIView *)background
            leftTable:(UITableView *)leftTable
           rightTable:(UITableView *)rightTable
              forward:(BOOL)forward
            complete:(void(^)())complete;
/**
 动画显示中间表格下拉菜单
 
 @param indicator
 @param centerTable
 @param background
 @param forward
 @param complete
 */
- (void)showIndicator:(CAShapeLayer *)indicator
           background:(UIView *)background
          centerTable:(UITableView *)centerTable
              forward:(BOOL)forward
             complete:(void(^)())complete;
/**
 动画显示集合视图下拉菜单
 
 @param indicator
 @param background
 @param collectionView
 @param forward
 @param complete
 */
- (void)showIndicator:(CAShapeLayer *)indicator
           background:(UIView *)background
       collectionView:(UICollectionView *)collectionView
              forward:(BOOL)forward
            complete:(void(^)())complete;

@end
