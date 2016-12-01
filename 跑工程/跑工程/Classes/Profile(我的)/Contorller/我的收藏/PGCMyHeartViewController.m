//
//  PGCMyHeartViewController.m
//  跑工程
//
//  Created by leco on 2016/12/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCMyHeartViewController.h"
#import "BackgroundView.h"
#import "PGCProjectRootViewController.h"
#import "PGCDemandCollectVC.h"
#import "PGCSupplyCollectVC.h"

@interface PGCMyHeartViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *dataSource;

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCMyHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewController];
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.title = @"我的收藏";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)initViewController
{
    PGCProjectRootViewController *rootVC = [[PGCProjectRootViewController alloc] init];
    PGCDemandCollectVC *demandVC = [[PGCDemandCollectVC alloc] init];
    PGCSupplyCollectVC *suppllyVC = [[PGCSupplyCollectVC alloc] init];
    
    self.dataSource = @[@{@"title":@"项目收藏", @"vc":rootVC},
                        @{@"title":@"招采信息收藏", @"vc":demandVC},
                        @{@"title":@"供应信息收藏", @"vc":suppllyVC}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kTableViewCell = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewCell];
        BackgroundView *bg = [[BackgroundView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = bg;
        cell.backgroundView = bg;
        cell.textLabel.highlightedTextColor = PGCTintColor;
        cell.textLabel.textColor = PGCTextColor;
        UIImage *nor_image = [UIImage imageNamed:@"icon_chose_arrow_nor"];
        UIImage *sel_image = [UIImage imageNamed:@"icon_chose_arrow_sel"];
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:nor_image highlightedImage:sel_image];
        cell.accessoryView = accessoryView;
        
        cell.textLabel.text = [self.dataSource[indexPath.row] objectForKey:@"title"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            PGCProjectRootViewController *rootVC = [self.dataSource[indexPath.row] objectForKey:@"vc"];
            rootVC.title = @"我的收藏";
            rootVC.bottomBtnTitle = @"取消收藏";
            rootVC.projectType = 2;
            [self.navigationController pushViewController:rootVC animated:true];
        }
            break;
        case 1:
        {
            PGCDemandCollectVC *demandVC = [self.dataSource[indexPath.row] objectForKey:@"vc"];
            [self.navigationController pushViewController:demandVC animated:true];
        }
            break;
        default:
        {
            PGCSupplyCollectVC *supplyVC = [self.dataSource[indexPath.row] objectForKey:@"vc"];
            [self.navigationController pushViewController:supplyVC animated:true];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 50;
        _tableView.bounces = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
