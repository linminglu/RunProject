//
//  PGCProjectRootViewController.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectRootViewController.h"
#import "JCAlertView.h"

@interface PGCProjectRootViewController ()

@property (strong, nonatomic) UIView *bottomView;

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self barButtonItem]];
    
    [self.view addSubview:self.tableView];
}

- (UIButton *)barButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 55, 40);
    [button setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelInset = [button.titleLabel intrinsicContentSize].width - button.imageView.width - button.width;
    CGFloat imageInset = button.imageView.width - button.width - button.titleLabel.width;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    return button;
}

- (void)respondsToEdit:(UIButton *)sender {
    _isEditing = !_isEditing;
    self.tableView.editing = _isEditing;
    
    [self animateBottomView:self.bottomView show:_isEditing complete:^{
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectInfoCell];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[PGCProjectInfoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UIButton Events
- (void)respondsToDelete:(UIButton *)sender {
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示:" Message:@"是否确定删除?" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"否" Click:^{
        
    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"是" Click:^{
        
    }];
}

- (void)respondsToCancel:(UIButton *)sender {
    _isEditing = false;
    self.tableView.editing = false;
    
    [self animateBottomView:self.bottomView show:_isEditing complete:^{
        
    }];
}


#pragma mark - Animation

- (void)animateBottomView:(UIView *)bottomView show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
            [self.view addSubview:bottomView];
            
            self.tableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
            
            self.tableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT);
        } completion:^(BOOL finished) {
            [bottomView removeFromSuperview];
        }];
    }
    complete();
}


#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCProjectInfoCell class] forCellReuseIdentifier:kProjectInfoCell];
    }
    return _tableView;
}

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width / 2, _bottomView.height)];
        delete.backgroundColor = PGCTintColor;
        [delete setTitle:_bottomBtnTitle forState:UIControlStateNormal];
        [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(respondsToDelete:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:delete];
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(delete.right, 0, _bottomView.width / 2, _bottomView.height)];
        cancel.backgroundColor = [UIColor whiteColor];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:PGCTextColor forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(respondsToCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancel];
    }
    return _bottomView;
}

@end
