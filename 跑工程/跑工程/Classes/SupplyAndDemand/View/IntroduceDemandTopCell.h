//
//  IntroduceDemandTopCell.h
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCDemand, IntroduceDemandTopCell;

@protocol IntroduceDemandTopCellDelegate <NSObject>

@optional
- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView selectArea:(UIButton *)area;
- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView slectDemand:(UIButton *)demand;

@end

static NSString * const kIntroduceDemandTopCell = @"IntroduceDemandTopCell";

@interface IntroduceDemandTopCell : UITableViewCell

@property (weak, nonatomic) id <IntroduceDemandTopCellDelegate> delegate;
@property (strong, nonatomic) PGCDemand *topDemand;/** 需求详情模型 */

@end
