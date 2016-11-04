//
//  PGCDemandCollectVC.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandCollectVC.h"
#import "PGCSupplyAndDemandCell.h"
#import "PGCDemandCollectDetailVC.h"
#import "JCAlertView.h"

@interface PGCDemandCollectVC ()

@property (strong, nonatomic) UIView *bottomView;

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCDemandCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"我的收藏";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self barButtonItem]];
    
    [self.rootTableView registerClass:[PGCSupplyAndDemandCell class] forCellReuseIdentifier:kSupplyAndDemandCell];
}


- (UIButton *)barButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 55, 40);
    [button setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [button setTintColor:PGCTextColor];
    [button addTarget:self action:@selector(respondsToCollectEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelInset = [button.titleLabel intrinsicContentSize].width - button.imageView.width - button.width;
    CGFloat imageInset = button.imageView.width - button.width - button.titleLabel.width;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, labelInset, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageInset);
    
    return button;
}


#pragma mark - Event

- (void)respondsToCollectEdit:(UIBarButtonItem *)sender {
    
    self.rootTableView.editing = !self.rootTableView.editing;
    
    [self animateBottomView:self.bottomView show:self.rootTableView.editing complete:^{
        
    }];
}

- (void)respondsToDelete:(UIButton *)sender {
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示:" Message:@"是否确定删除?" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"否" Click:^{
        
    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"是" Click:^{
        
    }];
}

- (void)respondsToCancel:(UIButton *)sender {
    [self.rootTableView setEditing:false animated:true];
    [self animateBottomView:self.bottomView show:false complete:^{
        
    }];
}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCSupplyAndDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupplyAndDemandCell];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[PGCSupplyAndDemandCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        return;
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false];
    
    PGCDemandCollectDetailVC *detailVC = [PGCDemandCollectDetailVC new];
    
    [self.navigationController pushViewController:detailVC animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - Animation

- (void)animateBottomView:(UIView *)bottomView show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
            [self.view addSubview:bottomView];
            
            self.rootTableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
            
            self.rootTableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT);
        } completion:^(BOOL finished) {
            [bottomView removeFromSuperview];
        }];
    }
    complete();
}


#pragma mark - Getter

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width / 2, _bottomView.height)];
        delete.backgroundColor = PGCTintColor;
        [delete setTitle:@"删除" forState:UIControlStateNormal];
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
