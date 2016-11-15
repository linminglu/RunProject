//
//  PGCProjectRootViewController.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCProjectRootViewController : UIViewController

@property (copy, nonatomic) NSString *bottomBtnTitle;/** 底部按钮标题 */
@property (assign, nonatomic) int projectType;/** 收藏与浏览的类型 */

@end
