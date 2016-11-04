//
//  PGCIntroduceDetailTopView.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCIntroduceDetailTopView;


@protocol PGCIntroduceDetailTopViewDelegate <NSObject>

@optional

- (void)introduceDetailTopView:(PGCIntroduceDetailTopView *)topView selectArea:(UIButton *)sender;

- (void)introduceDetailTopView:(PGCIntroduceDetailTopView *)topView slectDemand:(UIButton *)demand;

@end

@interface PGCIntroduceDetailTopView : UIView

@property (weak, nonatomic) id <PGCIntroduceDetailTopViewDelegate> delegate;

- (instancetype)initWithModel:(id)model;

@end
