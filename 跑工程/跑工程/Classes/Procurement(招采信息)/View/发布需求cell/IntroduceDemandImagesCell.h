//
//  IntroduceDemandImagesCell.h
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Images, IntroduceDemandImagesCell;

@protocol IntroduceDemandImagesCellDelegate <NSObject>

- (void)introduceDemandImagesCell:(IntroduceDemandImagesCell *)cell imageView:(UIImageView *)imageView;

- (void)introduceDemandImagesCell:(IntroduceDemandImagesCell *)cell deleteBtn:(UIButton *)deleteBtn;

@end

static NSString * const kIntroduceDemandImagesCell = @"IntroduceDemandImagesCell";

@interface IntroduceDemandImagesCell : UITableViewCell

@property (weak, nonatomic) id <IntroduceDemandImagesCellDelegate> delegate;
@property (strong, nonatomic) UIImage *introduceImage;/** 发布image */
@property (strong, nonatomic) Images *publishImage;/** 发布的图片 */

- (void)setButtonHidden:(BOOL)hidden;

@end
