//
//  PGCSearchView.h
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCSearchView;

@protocol PGCSearchViewDelegate <NSObject>

- (void)searchView:(PGCSearchView *)searchView didSelectedSearchButton:(UIButton *)sender;

@end

@interface PGCSearchView : UIView

@property (weak, nonatomic) id <PGCSearchViewDelegate> delegate;

@end
