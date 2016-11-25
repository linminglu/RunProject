//
//  PGCSearchViewController.m
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchViewController.h"
#import "PGCSearchView.h"

@interface PGCSearchViewController () <PGCSearchViewDelegate>

@property (strong, nonatomic) PGCSearchView *searchView;/** 搜索框 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchView];
}



#pragma mark - PGCSearchViewDelegate

- (void)searchView:(PGCSearchView *)searchView didSelectedSearchButton:(UIButton *)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark - Getter

- (PGCSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[PGCSearchView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + 5, SCREEN_WIDTH, 40)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.delegate = self;
    }
    return _searchView;
}

@end
