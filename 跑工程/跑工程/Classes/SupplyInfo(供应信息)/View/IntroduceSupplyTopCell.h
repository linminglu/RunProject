//
//  IntroduceSupplyTopCell.h
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCSupply, IntroduceSupplyTopCell;

typedef NS_ENUM(NSUInteger, SupplyTextFieldTag) {
    SupplyTitleTF,
    SupplyCompanyTF,
    SupplyAddressTF,
};

@protocol IntroduceSupplyTopCellDelegate <NSObject>

@optional
- (void)introduceSupplyTopCell:(IntroduceSupplyTopCell *)topView selectArea:(UIButton *)sender;
- (void)introduceSupplyTopCell:(IntroduceSupplyTopCell *)topView selectDemand:(UIButton *)demand;

@end

static NSString * const kIntroduceSupplyTopCell = @"IntroduceSupplyTopCell";

@interface IntroduceSupplyTopCell : UITableViewCell

@property (weak, nonatomic) id <IntroduceSupplyTopCellDelegate> delegate;
@property (strong, nonatomic) PGCSupply *topSupply;/** 供应详情模型 */

@end
