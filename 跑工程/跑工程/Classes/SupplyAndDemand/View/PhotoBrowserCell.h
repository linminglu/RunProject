//
//  PhotoBrowserCell.h
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCPhoto.h"
@class PhotoBrowserCell;

@protocol PhotoBrowserCellDelegate <NSObject>

- (void)didSelectedPhotoBrowserCell:(PhotoBrowserCell *)cell;

- (void)longPressPhotoBrowserCell:(PhotoBrowserCell *)cell;

@end

static NSString * const kPhotoBrowserCell = @"PhotoBrowserCell";

@interface PhotoBrowserCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic ,assign) id<PhotoBrowserCellDelegate> delegate;

@property (nonatomic, strong) PGCPhoto *photo;

@end
