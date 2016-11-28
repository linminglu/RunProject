//
//  DemandDetailFilesCell.h
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Files;

static NSString * const kDemandDetailFilesCell = @"DemandDetailFilesCell";

@interface DemandDetailFilesCell : UITableViewCell

@property (strong, nonatomic) NSArray<Files *> *fileDatas;/** 需求文件数组 */

@end
