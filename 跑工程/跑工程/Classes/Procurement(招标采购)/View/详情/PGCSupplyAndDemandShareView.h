//
//  PGCSupplyAndDemandShareView.h
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCSupplyAndDemandShareView;

@protocol PGCSupplyAndDemandShareViewDelegate <NSObject>

@optional
/**
 分享到QQ好友

 @param shareView
 @param QQFriend
 */
- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqFriend:(UIButton *)qqFriend;
/**
 分享到QQ空间

 @param shareView
 @param qqZone
 */
- (void)shareView:(PGCSupplyAndDemandShareView *)shareView qqZone:(UIButton *)qqZone;
/**
 分享到微信好友

 @param shareView
 @param weChat
 */
- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChat:(UIButton *)weChat;
/**
 分享到朋友圈

 @param shareView
 @param friends 
 */
- (void)shareView:(PGCSupplyAndDemandShareView *)shareView weChatFriends:(UIButton *)friends;

@end

@interface PGCSupplyAndDemandShareView : UIView

@property (weak, nonatomic) id <PGCSupplyAndDemandShareViewDelegate> delegate;
/**
 显示分享视图
 */
- (void)showShareView;

@end
