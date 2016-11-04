
//
//  PGCNotice.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#ifndef PGCNotice_h
#define PGCNotice_h

1.AFNetWorking-->3.1;
2.SDWebImage-->3.7;
3.提示框参考"HHPointHUD.h";
4.字典模型转换使用"MJExtion";
5.刷新使用"MJRefresh";
6.用户本地信息存储于"PGCUserInfo.h";
7.actionSheet调用:
HyActionSheet *action = [[HyActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"收藏",@"分享"] AttachTitle:@"收藏后可以在个人中心随时查到该条问题 \n 回答的不错,快分享给朋友吧"];
[action ChangeTitleColor:[UIColor redColor] AndIndex:1];

[action ButtonIndex:^(NSInteger Buttonindex) {
    
}];
8.登录按钮:"HyLoglnButton"

//UIViewController *controller = [SecondViewController new];
//UINavigationController *nai = [[UINavigationController alloc] initWithRootViewController:controller];
//nai.transitioningDelegate = self;
//[self presentViewController:nai animated:YES completion:nil];

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//
//    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
//}
//
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//
//    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
//}
9.


#endif /* PGCNotice_h */
