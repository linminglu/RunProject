//
//  PGCContactInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactInfoController.h"
#import "PGCContactInfoCell.h"
#import "PGCProjectCell.h"

@interface PGCContactInfoController () <UITableViewDelegate, UITableViewDataSource>

#pragma mark 控件坐标属性
//头像X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewX;
//姓名X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelX;
//项目名X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectLabelX;
//个人资料按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactInfoBtnX;
//两个按钮中间分割线X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SeparatorViewX;
//参与的项目按钮X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectBtnX;
#pragma mark 控件属性
//个人资料按钮
@property (weak, nonatomic) IBOutlet UIButton *contactInfoBtn;
//参与的项目按钮
@property (weak, nonatomic) IBOutlet UIButton *projectBtn;
//tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@end


@implementation PGCContactInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    self.contactNameLabel.text = self.nameStr;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PGCContactInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PGCProjectCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
    // 设置控件的X
    self.iconImageViewX.constant = (SCREEN_WIDTH - 50) / 2;
    self.nameLabelX.constant = (SCREEN_WIDTH - 80) / 2;
    self.projectLabelX.constant = (SCREEN_WIDTH - 80) / 2;
    self.contactInfoBtnX.constant = (SCREEN_WIDTH / 2 - 80) / 2;
    self.SeparatorViewX.constant = SCREEN_WIDTH  / 2;
    self.projectBtnX.constant = (SCREEN_WIDTH / 2- 80) / 2;
    
    // 设置初始状态为个人资料按钮被选中，个人资料按钮用户交互停用
    self.contactInfoBtn.selected = YES;
    self.contactInfoBtn.userInteractionEnabled = NO;
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除联系人" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToDeleteContact:)];
}


#pragma mark - Evetns

- (void)respondsToDeleteContact:(UIBarButtonItem *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)contactInfoBtnClick:(id)sender {
    // 点击个人资料按钮后个人资料用户交互停用，参与的项目按钮用户交互启用，个人资料按钮为选中状态，参与的项目按钮为未选择状态
    self.contactInfoBtn.userInteractionEnabled = NO;
    self.projectBtn.userInteractionEnabled = YES;
    self.contactInfoBtn.selected = YES;
    self.projectBtn.selected = NO;
    [self.tableView reloadData];
    
    NSLog(@"个人资料");
}

- (IBAction)projectBtnClick:(id)sender {
    self.contactInfoBtn.userInteractionEnabled = YES;
    self.projectBtn.userInteractionEnabled = NO;
    self.contactInfoBtn.selected = NO;
    self.projectBtn.selected = YES;
    NSLog(@"参与的项目");
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.contactInfoBtn.isSelected == YES) {
        
    return 1;
    }
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (self.contactInfoBtn.isSelected == YES) {
        //    去除cell分界线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        PGCContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[PGCContactInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        //        点击cell不变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    PGCProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    if (!cell) {
        cell = [[PGCProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    
    //        点击cell不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contactInfoBtn.isSelected == YES) {
        return 350;
    }
    return 40;
}

@end
