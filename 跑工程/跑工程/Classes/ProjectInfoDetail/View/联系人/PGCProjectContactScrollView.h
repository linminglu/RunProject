//
//  PGCProjectContactScrollView.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kProjectContactScrollView = @"PGCProjectContactScrollView";

@interface PGCProjectContactScrollView : UICollectionViewCell

@property (copy, nonatomic) NSArray *contactDataSource;/** 联系人数据源 */

@end
