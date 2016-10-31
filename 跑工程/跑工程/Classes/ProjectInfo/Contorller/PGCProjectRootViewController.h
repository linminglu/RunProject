//
//  PGCProjectRootViewController.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCProjectRootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSources;

@property (assign, nonatomic) BOOL isEditing;

@property (copy, nonatomic) NSString *bottomBtnTitle;

@end
