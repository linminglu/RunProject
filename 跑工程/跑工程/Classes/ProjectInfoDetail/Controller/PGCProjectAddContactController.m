//
//  PGCProjectAddContactController.m
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectAddContactController.h"
#import "PGCAddContactTableCell.h"
#import "PGCAddContactRemarkCell.h"
#import "PGCProjectDetailTagView.h"
#import "PGCHintAlertView.h"
#import "PGCProjectContact.h"
#import "PGCContact.h"
#import "PGCContactAPIManager.h"

@interface PGCProjectAddContactController () <UITableViewDataSource, UITableViewDelegate, PGCAddContactTableCellDelegate, PGCAddContactRemarkCellDelegate, PGCHintAlertViewDelegate>

@property (copy, nonatomic) NSArray *headerTitles;/** 表格视图的头视图标题 */
@property (copy, nonatomic) NSArray *cellTitles;/** 表格视图标题文字的数据源 */
@property (copy, nonatomic) NSArray *placeholders;/** 文本输入框的提示语 */
@property (strong, nonatomic) UILabel *nameLabel;/** 名字输入框 */
@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (strong, nonatomic) PGCContact *contact;/** 联系人 */

- (void)initializeDataSource;/** 初始化数据源 */
- (void)initializeUserInterface;/** 初始化用户界面 */

@end

@implementation PGCProjectAddContactController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource
{
    _headerTitles = @[@"联系方式", @"详细信息", @"备注"];
    _cellTitles = @[@[@"电   话：", @"传   真：", @"座   机：", @"邮   箱："],
                    @[@"职   位：", @"公   司：", @"地   址："],
                    @[@"备注"]];
    _placeholders = @[@[@"请输入电话", @"请输入传真", @"请输入座机", @"请输入邮箱"],
                      @[@"未填写", @"未填写", @"未填写"],
                      @[@"请输入备注"]];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"添加联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToBarItemSave:)];
    
    [self.view addSubview:self.tableView];
}



#pragma mark - Events

- (void)respondsToBarItemSave:(UIBarButtonItem *)sender
{
    [self.view endEditing:true];
    
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    
    NSMutableDictionary *params = self.contact.mj_keyValues;
    [params setObject:@(user.user_id) forKey:@"user_id"];
    [params setObject:@"iphone" forKey:@"client_type"];
    [params setObject:manager.token.token forKey:@"token"];
    NSLog(@"%@", params);
    MBProgressHUD *hud = [PGCProgressHUD showProgressHUD:self.view label:@"正在添加联系人..."];
    [PGCContactAPIManager addContactRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
        [hud hideAnimated:true];
        
        if (status == RespondsStatusSuccess) {
            PGCHintAlertView *hintAlert = [[PGCHintAlertView alloc] initWithContent:@"该联系人已成功添加到《通讯录》，方便你查找和联系。"];
            hintAlert.delegate = self;
            [hintAlert showHintAlertView];
        } else {            
            [PGCProgressHUD showAlertWithTarget:self title:@"添加失败：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                
            }];
        }
    }];
}



#pragma mark - PGCAddContactTableCellDelegate

- (void)addContactTableCell:(PGCAddContactTableCell *)cell textField:(UITextField *)textField
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section < 2) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0: self.contact.phone = cell.addContactTF.text; break;
                case 1: self.contact.fax = cell.addContactTF.text; break;
                case 2: self.contact.telephone = cell.addContactTF.text; break;
                default: self.contact.email = cell.addContactTF.text; break;
            }
        }
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0: self.contact.position = cell.addContactTF.text; break;
                case 1: self.contact.company = cell.addContactTF.text; break;
                default: self.contact.address = cell.addContactTF.text; break;
            }
        }
    }
}



#pragma mark - PGCAddContactRemarkCellDelegate

- (void)addContactRemarkCell:(PGCAddContactRemarkCell *)cell textView:(UITextView *)textView
{
    self.contact.remark = textView.text;
}



#pragma mark - PGCHintAlertViewDelegate

- (void)hintAlertView:(PGCHintAlertView *)hintAlertView known:(UIButton *)known
{
    [self.navigationController popViewControllerAnimated:true];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 2) {
        PGCAddContactTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddContactTableCell];
        cell.delegate = self;
        cell.addContactTitle.text = _cellTitles[indexPath.section][indexPath.row];
        cell.addContactTF.placeholder = _placeholders[indexPath.section][indexPath.row];
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0: cell.addContactTF.text = self.contact.phone ? self.contact.phone : @""; break;
                    case 1: cell.addContactTF.text = self.contact.fax ? self.contact.fax : @"";  break;
                    case 2: cell.addContactTF.text = self.contact.telephone ? self.contact.telephone : @""; break;
                    default: cell.addContactTF.text = self.contact.email ? self.contact.email : @""; break;
                }
            }
                break;
            default:
            {
                switch (indexPath.row) {
                    case 0: cell.addContactTF.text = self.contact.position ? self.contact.position : @""; break;
                    case 1: cell.addContactTF.text = self.contact.company ? self.contact.company : @""; break;
                    default:cell.addContactTF.text = self.contact.address ? self.contact.address : @""; break;
                }
            }
                break;
        }
        return cell;
        
    } else {
        PGCAddContactRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddContactRemarkCell];
        cell.delegate = self;
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PGCProjectDetailTagView *tagView = [[PGCProjectDetailTagView alloc] initWithTitle:_headerTitles[section]];
    tagView.frame = CGRectMake(0, 0, tableView.width, 40);
    return tagView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section < 2 ? 45 : 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


#pragma mark - Setter

- (void)setProjectCon:(PGCProjectContact *)projectCon
{
    _projectCon = projectCon;
    
    self.contact = [[PGCContact alloc] init];
    // 将项目联系人的属性值 赋制给 联系人的属性
    self.contact.name = projectCon.name;
    self.contact.sex = projectCon.sex;
    self.contact.phone = projectCon.phone;
    self.contact.telephone = projectCon.telephone;
    self.contact.position = projectCon.position;
    self.contact.company = projectCon.company;
    self.contact.address = projectCon.address;
    // 给姓名标签赋值
    self.nameLabel.text = self.contact.name;
    
    [self.tableView reloadData];
}


#pragma mark - Getter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, STATUS_AND_NAVIGATION_HEIGHT, 60, 50)];
        nameTitle.textColor = PGCTextColor;
        nameTitle.font = SetFont(16);
        nameTitle.text = @"姓名：";
        [self.view addSubview:nameTitle];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameTitle.right_sd, STATUS_AND_NAVIGATION_HEIGHT, self.view.width_sd - nameTitle.right_sd - 15, 50)];
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.font = SetFont(16);
        [self.view addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.nameLabel.bottom_sd, self.view.width_sd, self.view.height_sd - self.nameLabel.bottom_sd) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PGCAddContactTableCell class] forCellReuseIdentifier:kAddContactTableCell];
        [_tableView registerClass:[PGCAddContactRemarkCell class] forCellReuseIdentifier:kAddContactRemarkCell];
    }
    return _tableView;
}


@end
