//
//  PGCCollectRootVC.h
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCCollectRootVC : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *collectTableView;

@end
