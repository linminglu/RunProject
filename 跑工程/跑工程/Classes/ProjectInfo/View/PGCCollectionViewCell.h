//
//  PGCCollectionViewCell.h
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kPGCCollectionViewCell = @"PGCCollectionViewCell";

@interface PGCCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *collectionLabel;

@property (strong, nonatomic) UIView *centerView;

@end
