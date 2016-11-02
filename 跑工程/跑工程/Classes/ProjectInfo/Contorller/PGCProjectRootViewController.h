//
//  PGCProjectRootViewController.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCProjectInfoCell.h"


@interface PGCProjectRootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 表格视图
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 数据源
 */
@property (strong, nonatomic) NSMutableArray *dataSources;
/**
 是否编辑状态
 */
@property (assign, nonatomic) BOOL isEditing;
/**
 底部按钮标题
 */
@property (copy, nonatomic) NSString *bottomBtnTitle;

@end
