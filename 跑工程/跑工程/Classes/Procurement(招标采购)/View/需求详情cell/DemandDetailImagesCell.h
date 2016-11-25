//
//  DemandDetailImagesCell.h
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Images;

static NSString * const kDemandDetailImagesCell = @"DemandDetailImagesCell";

@interface DemandDetailImagesCell : UITableViewCell

@property (copy, nonatomic) NSArray<Images *> *imageDatas;/** 需求图片数组 */

@end
