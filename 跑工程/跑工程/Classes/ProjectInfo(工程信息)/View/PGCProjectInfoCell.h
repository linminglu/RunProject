//
//  PGCProjectInfoCell.h
//  跑工程
//
//  Created by leco on 16/10/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProjectInfo;

static NSString * const kProjectInfoCell = @"ProjectInfoCell";

@interface PGCProjectInfoCell : UITableViewCell

@property (strong, nonatomic) PGCProjectInfo *project;/** 项目模型 */

@end
