//
//  PGCDropMenu+Custom.m
//  跑工程
//
//  Created by leco on 2016/11/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropMenu+Custom.h"


@implementation PGCDropMenu (Custom)


#pragma mark - Setter

/**
 创建按钮背景layer

 @param position
 @return
 */
- (CALayer *)createBgLayerWithPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height - 1);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    return layer;
}

/**
 创建按钮三角指示器layer

 @param color 颜色
 @param point 旋转角度
 @return
 */
- (CAShapeLayer *)createIndicatorWithPosition:(CGPoint)point {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = PGCTextColor.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

/**
 创建按钮文字layer

 @param string
 @param color
 @param point
 @return
 */
- (CATextLayer *)createTextLayerWithString:(NSString *)string position:(CGPoint)point {
    
    CGSize size = [self textSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / 3) - 30) ? size.width : self.frame.size.width / 3 - 30;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = PGCTextColor.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    
    return layer;
}

/**
 计算按钮标题文字的size

 @param string
 @return
 */
- (CGSize)textSizeWithString:(NSString *)string {
    CGFloat width = [string sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)].width;
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName:SetFont(14)}
                                       context:nil].size;
    
    return size;
}
/**
 创建下划分割线
 
 @param point
 @return
 */
- (CAShapeLayer *)createSeparatorLineWithPosition:(CGPoint)point {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - 1)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - 1)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = RGB(240, 240, 240).CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

#pragma mark - Animation

/**
 黑色背景的动画
 
 @param view
 @param show
 @param complete
 */
- (void)showBackgroundView:(UIView *)view
                      show:(BOOL)show
                  complete:(void(^)())complete {
    
    if (show) {
        [self.superview addSubview:view];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

/**
 按钮指示器的动画
 
 @param indicator
 @param forward
 @param complete
 */
- (void)showIndicator:(CAShapeLayer *)indicator
              forward:(BOOL)forward
             complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[@0, @(M_PI)] : @[@(M_PI), @0];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}

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
             complete:(void(^)())complete {
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    
    if (show) {
        CGFloat tableHeight = self.superview.frame.size.height * 0.6;
        
        if (leftTable) {
            leftTable.frame = CGRectMake(self.origin.x, y, self.frame.size.width / 2, 0);
            [self.superview addSubview:leftTable];
        }
        if (rightTable) {
            rightTable.frame = CGRectMake(self.origin.x + leftTable.frame.size.width, y, self.frame.size.width / 2, 0);
            [self.superview addSubview:rightTable];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            if (leftTable) {
                leftTable.frame = CGRectMake(self.origin.x, y, self.frame.size.width / 2, tableHeight);
            }
            if (rightTable) {
                rightTable.frame = CGRectMake(self.origin.x + leftTable.frame.size.width, y, self.frame.size.width / 2, tableHeight);
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            if (leftTable) {
                leftTable.frame = CGRectMake(self.origin.x, y, self.frame.size.width / 2, 0);
            }
            if (rightTable) {
                rightTable.frame = CGRectMake(self.origin.x + leftTable.frame.size.width, y, self.frame.size.width / 2, 0);
            }
        } completion:^(BOOL finished) {
            if (leftTable) {
                [leftTable removeFromSuperview];
            }
            if (rightTable) {
                [rightTable removeFromSuperview];
            }
        }];
    }
    complete();
}

/**
 动画显示两个表格下拉菜单

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
            complete:(void(^)())complete {
    
    [self showIndicator:indicator forward:forward complete:^{
        
        [self showBackgroundView:background show:forward complete:^{
            
            [self showLeftTable:leftTable rightTable:rightTable show:forward complete:^{
                
            }];
        }];
    }];
    complete();
}

/**
 中间表格视图的动画

 @param centerTable
 @param show
 @param complete
 */
- (void)showCenterTable:(UITableView *)centerTable
                   show:(BOOL)show
               complete:(void(^)())complete {
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    
    if (show) {
        CGFloat tableHeight = self.superview.frame.size.height * 0.5;
        
        if (centerTable) {
            centerTable.frame = CGRectMake(self.origin.x, y, self.frame.size.width, 0);
            [self.superview addSubview:centerTable];
        }
        [UIView animateWithDuration:0.25 animations:^{
            if (centerTable) {
                centerTable.frame = CGRectMake(self.origin.x, y, self.frame.size.width, tableHeight);
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            if (centerTable) {
                centerTable.frame = CGRectMake(self.origin.x, y, self.frame.size.width, 0);
            }
        } completion:^(BOOL finished) {
            if (centerTable) {
                [centerTable removeFromSuperview];
            }
        }];
    }
    complete();

}
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
             complete:(void(^)())complete {
    
    [self showIndicator:indicator forward:forward complete:^{
        
        [self showBackgroundView:background show:forward complete:^{
            
            [self showCenterTable:centerTable show:forward complete:^{
                
            }];
        }];
    }];
    complete();
}


/**
 下拉菜单集合视图的动画

 @param collectionView
 @param show
 @param complete
 */
- (void)showCollectionView:(UICollectionView *)collectionView
                      show:(BOOL)show
                  complete:(void(^)())complete {
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    
    if (show) {
        CGFloat height = 0;
        
        if (collectionView) {
            collectionView.frame = CGRectMake(self.origin.x, y, self.frame.size.width, 0);
            [self.superview addSubview:collectionView];
            
            NSInteger number = [collectionView numberOfItemsInSection:0];
            // 根据item的个数来计算集合视图的高度
            if ((number % 3) > 0) {
                height = (number / 3 + 1) * 65;
            } else {
                height = number / 3 * 65;
            }
        }
        [UIView animateWithDuration:0.25 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(self.origin.x, y, self.frame.size.width, height + 10);
            }
        }];
        
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(self.origin.x, y, self.frame.size.width, 0);
            }
        } completion:^(BOOL finished) {
            if (collectionView) {
                [collectionView removeFromSuperview];
            }
        }];
    }
    complete();
}

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
            complete:(void(^)())complete {
    
    [self showIndicator:indicator forward:forward complete:^{
        
        [self showBackgroundView:background show:forward complete:^{
            
            [self showCollectionView:collectionView show:forward complete:^{
                
            }];
        }];
    }];
    complete();
}

@end
