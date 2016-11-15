//
//  PGCContacInfoHeaderView.h
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCContacInfoHeaderView, PGCContact;

@protocol PGCContacInfoHeaderViewDelegate <NSObject>

@optional
- (void)contactInfoHeaderView:(PGCContacInfoHeaderView *)headerView contactInfoBtn:(UIButton *)contactInfoBtn;
- (void)contactInfoHeaderView:(PGCContacInfoHeaderView *)headerView projectsBtn:(UIButton *)projectsBtn;

@end

static NSString * const kContacInfoHeaderView = @"PGCContacInfoHeaderView";

@interface PGCContacInfoHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) id <PGCContacInfoHeaderViewDelegate> delegate;
@property (strong, nonatomic) PGCContact *contactHeader;/** 联系人模型 */

@end
