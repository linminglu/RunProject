//
//  PGCDetailSubview2.h
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCDetailSubviewBottom;

@protocol PGCDetailSubviewBottomDelegate <NSObject>

@optional
- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom callPhone:(UIButton *)callPhone;
- (void)detailSubviewBottom:(PGCDetailSubviewBottom *)bottom checkMoreContact:(UIButton *)checkMoreContact;

@end

@interface PGCDetailSubviewBottom : UIView

@property (weak, nonatomic) id <PGCDetailSubviewBottomDelegate> delegate;

- (instancetype)initWithModel:(id)model;

@end
