//
//  PGCProjectCell.h
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProjectInfo;

static NSString * const kPGCProjectCell = @"PGCProjectCell";

@interface PGCProjectCell : UITableViewCell

@property (strong, nonatomic) PGCProjectInfo *projectInfo;/** 联系人参与的项目 */

@end
