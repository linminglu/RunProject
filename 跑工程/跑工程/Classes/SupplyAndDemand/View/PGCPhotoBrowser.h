//
//  PGCPhotoBrowser.h
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserCell.h"
@class PGCPhoto;

@protocol BrowerCellDelegate <NSObject>

@optional
- (void)collectionViewCell:(PhotoBrowserCell *)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PGCPhotoBrowser : UIViewController

@property (copy, nonatomic) NSArray<PGCPhoto *> *photos;

@property (assign, nonatomic) NSUInteger selectedIndex;

@property (weak, nonatomic) id <BrowerCellDelegate> delegate;

- (void)show;

@end
