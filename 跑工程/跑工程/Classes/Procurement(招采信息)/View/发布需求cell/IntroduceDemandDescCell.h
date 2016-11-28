//
//  IntroduceDemandDescCell.h
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCDemand;

static NSString * const kIntroduceDemandDescCell = @"IntroduceDemandDescCell";

@interface IntroduceDemandDescCell : UITableViewCell

@property (strong, nonatomic) PGCDemand *demandDesc;/** 需求详细介绍 */

@end
