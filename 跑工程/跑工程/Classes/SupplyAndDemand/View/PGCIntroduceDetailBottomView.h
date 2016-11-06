//
//  PGCIntroduceDetailBottomView.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCIntroduceDetailBottomView;


@protocol PGCIntroduceDetailBottomViewDelegate <NSObject>

@optional
- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView deleteContact:(UIButton *)deleteContact;
- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView addContact:(UIButton *)addContact;
- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView addImage:(UIButton *)addImage;
- (void)introduceDetailBottomView:(PGCIntroduceDetailBottomView *)topView deleteImage:(UIButton *)deleteImage;

@end

@interface PGCIntroduceDetailBottomView : UIView

@property (weak, nonatomic) id <PGCIntroduceDetailBottomViewDelegate> delegate;

- (instancetype)initWithModel:(id)model;

@end
