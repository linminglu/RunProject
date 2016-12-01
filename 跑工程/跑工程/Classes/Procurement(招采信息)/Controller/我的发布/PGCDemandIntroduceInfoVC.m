//
//  PGCDemandIntroduceInfoVC.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDemandIntroduceInfoVC.h"
#import "PGCAreaAndTypeRootVC.h"
#import "PGCProjectDetailTagView.h"
#import "PGCDemandAPIManager.h"
#import "IntroduceDemandTopCell.h"
#import "IntroduceDemandContactCell.h"
#import "IntroduceDemandDescCell.h"
#import "IntroduceDemandImagesCell.h"
#import "PGCAreaManager.h"
#import "PGCMaterialServiceTypes.h"
#import "PGCDemand.h"
#import "PGCOtherAPIManager.h"
#import "PGCHeadImage.h"

@interface PGCDemandIntroduceInfoVC () <UITableViewDataSource, UITableViewDelegate, IntroduceDemandTopCellDelegate, IntroduceDemandContactCellDelegate, IntroduceDemandImagesCellDelegate>

@property (strong, nonatomic) UITableView *tableView;/** 表格视图 */
@property (copy, nonatomic) NSArray *headerTitles;/** 头部视图标题 */
@property (strong, nonatomic) NSMutableArray *dataSource;/** 表格视图数据源 */
@property (strong, nonatomic) UIButton *introduceBtn;/** 底部发布按钮 */
@property (strong, nonatomic) NSMutableDictionary *params;/** 参数字典 */
@property (strong, nonatomic) NSMutableArray<UIImageView *> *publishImages;/** 上传的图片数组 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCDemandIntroduceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource
{
    _headerTitles = @[@" ", @"联系人", @"详细介绍", @"图片介绍"];
}


- (void)initializeUserInterface
{
    self.title = @"招采信息";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.introduceBtn];
}


#pragma mark - Private

- (BOOL)demandTopEdited
{
    if (!(self.demandDetail.title.length > 0)) {
        [MBProgressHUD showError:@"请填写标题" toView:self.view];
        return false;
    }
    if (!(self.demandDetail.start_time.length > 0)) {
        [MBProgressHUD showError:@"请填写开始时间" toView:self.view];
        return false;
    }
    if (!(self.demandDetail.company.length > 0)) {
        [MBProgressHUD showError:@"请填写采购单位" toView:self.view];
        return false;
    }
    if (!(self.demandDetail.address.length > 0)) {
        [MBProgressHUD showError:@"请填写地址" toView:self.view];
        return false;
    }
    if (!(self.demandDetail.city_id > 0)) {
        [MBProgressHUD showError:@"请选择地区" toView:self.view];
        return false;
    }
    if (!(self.demandDetail.type_id > 0)) {
        [MBProgressHUD showError:@"请选择类别" toView:self.view];
        return false;
    }
    return true;
}

- (BOOL)editedContacts:(NSMutableArray<Contacts *> *)contactArr
{
    for (Contacts *model in contactArr) {
        if (!(model.name.length > 0) || !(model.phone.length > 0)) {
            [MBProgressHUD showError:@"请先填写联系人信息" toView:self.view];
            return false;
        }
    }
    return true;
}

- (BOOL)editedImages:(NSMutableArray<Images *> *)imageArr
{
    for (Images *model in imageArr) {
        if (!model.isPublish) {
            [MBProgressHUD showError:@"请先添加图片" toView:self.view];
            return false;
        }
    }
    return true;
}

- (void)uploadPhotoes:(void(^)(void))complete
{
    NSDictionary *imageParams = @{@"clientType":@"user",
                                  @"category":@"1000",
                                  @"limit":@"false",
                                  @"width":@"200",
                                  @"height":@"200"};
    
    for (int i = 0; i < self.publishImages.count; i++) {
        UIImage *image = self.publishImages[i].image;
        
        Images *photoModel = self.demandDetail.images[i];
        
        if (!photoModel.isPublish) {
            
            [PGCOtherAPIManager uploadImagesRequestWithParameters:@{@"jsonStr":[imageParams mj_JSONString]} images:@[image] responds:^(RespondsStatus status, NSString *message, PGCHeadImage *resultData) {
                if (status == RespondsStatusSuccess) {
                    
                    photoModel.id = resultData.id;
                    photoModel.image = resultData.path;
                    photoModel.isPublish = true;
                    
                    if (i == (self.publishImages.count - 1)) {
                        complete();
                    }
                } else {
                    [PGCProgressHUD showAlertWithTarget:self title:@"图片上传失败：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                        
                    }];
                }
            }];
        } else {
            if (i == (self.publishImages.count - 1)) {
                complete();
            }
        }
    }
}

- (NSString *)jsonStrFromModel
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.demandDetail.id > 0) {
        [dic setObject:@(self.demandDetail.id) forKey:@"id"];
    }
    [dic setObject:self.demandDetail.title forKey:@"title"];
    [dic setObject:self.demandDetail.company forKey:@"company"];
    [dic setObject:self.demandDetail.start_time forKey:@"start_time"];
    [dic setObject:self.demandDetail.end_time forKey:@"end_time"];
    [dic setObject:self.demandDetail.address forKey:@"address"];
    [dic setObject:@(self.demandDetail.city_id) forKey:@"city_id"];
    [dic setObject:@(self.demandDetail.type_id) forKey:@"type_id"];
    [dic setObject:self.demandDetail.desc forKey:@"description"];
    
    NSMutableArray *contacts = [NSMutableArray array];
    for (Contacts *contact in self.demandDetail.contacts) {
        [contacts addObject:@{@"name":contact.name, @"phone":contact.phone}];
    }
    [dic setObject:contacts forKey:@"contacts"];
    
    NSMutableArray *images = [NSMutableArray array];
    for (Images *image in self.demandDetail.images) {
        
        [images addObject:@{@"id":@(image.id),
                            @"path":image.image,
                            @"description":image.imageDec}];
    }
    [dic setObject:images forKey:@"images"];
    
    return [dic mj_JSONString];
}


#pragma mark - Event

- (void)respondsToIntroduceBtn:(UIButton *)sender
{
    if (![self demandTopEdited]) {
        return;
    }
    if (![self editedContacts:self.demandDetail.contacts]) {
        return;
    }
    if (!(self.demandDetail.desc.length > 0)) {
        [MBProgressHUD showError:@"请填写详细介绍" toView:self.view];
        return;
    }
    
    // 上传图片
    [self uploadPhotoes:^{
        
        if (![self editedImages:self.demandDetail.images]) {
            return;
        }
        
        PGCManager *manager = [PGCManager manager];
        [manager readTokenData];
        PGCUser *user = manager.token.user;
        [self.params setObject:@"iphone" forKey:@"client_type"];
        [self.params setObject:manager.token.token forKey:@"token"];
        [self.params setObject:@(user.user_id) forKey:@"user_id"];
        [self.params setObject:[self jsonStrFromModel] forKey:@"json_str"];
        
        MBProgressHUD *hud = [PGCProgressHUD showProgress:@"正在发布..." toView:self.view];
        [PGCDemandAPIManager addOrMidifyDemandWithParameters:self.params responds:^(RespondsStatus status, NSString *message, id resultData) {
            [hud hideAnimated:true];
            if (status == RespondsStatusSuccess) {
                [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                
                [PGCNotificationCenter postNotificationName:kProcurementInfoData object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:true];
            } else {
                [PGCProgressHUD showAlertWithTarget:self title:@"发布失败：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                    
                }];
            }
        }];
    }];
}

- (void)footerButtonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        // 在数据源中添加一个联系人对象
        Contacts *contact = [[Contacts alloc] init];
        [self.demandDetail.contacts addObject:contact];
    }
    if (sender.tag == 3) {
        if (self.publishImages.count >= 8) {
            [MBProgressHUD showError:@"最多只能上传8张照片" toView:self.view];
            return;
        }
        // 在数据源中添加一个图片对象
        Images *image = [[Images alloc] init];
        image.isPublish = false;
        [self.demandDetail.images addObject:image];
        
        [self.publishImages addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"加照片"]]];
    }
    [self.tableView reloadData];
}


#pragma mark - IntroduceDemandTopCellDelegate

- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView selectArea:(UIButton *)area
{
    PGCAreaAndTypeRootVC *areaVC = [[PGCAreaAndTypeRootVC alloc] init];
    areaVC.title = @"选择地区";
    areaVC.isSupply = false;
    areaVC.dataSource = [[PGCAreaManager manager] setAreaData];
    [areaVC.dataSource removeObjectAtIndex:0];
    
    __weak typeof(self) weakSelf = self;
    areaVC.areaBlock = ^(PGCProvince *province, PGCCity *city) {
        __strong typeof(weakSelf) strongSlef = weakSelf;
        NSString *areaStr = [province.province stringByAppendingString:city.city];
        [area setTitle:areaStr forState:UIControlStateNormal];
        
        strongSlef.demandDetail.province_id = province.id;
        strongSlef.demandDetail.province = province.province;
        strongSlef.demandDetail.city_id = city.id;
        strongSlef.demandDetail.city = city.city;
    };
    [self.navigationController pushViewController:areaVC animated:true];
}

- (void)introduceDemandTopCell:(IntroduceDemandTopCell *)topView selectDemand:(UIButton *)demand
{
    PGCAreaAndTypeRootVC *demandVC = [[PGCAreaAndTypeRootVC alloc] init];
    demandVC.title = @"选择需求类别";
    demandVC.isSupply = false;
    demandVC.dataSource = [[PGCMaterialServiceTypes materialServiceTypes] setMaterialTypes];
    [demandVC.dataSource removeObjectAtIndex:0];
    
    __weak typeof(self) weakSelf = self;
    demandVC.typeBlock = ^(NSMutableArray<PGCMaterialServiceTypes *> *types) {
        __strong typeof(weakSelf) strongSlef = weakSelf;
        
        [demand setTitle:types.firstObject.name forState:UIControlStateNormal];
        
        strongSlef.demandDetail.type_name = types.firstObject.name;
        strongSlef.demandDetail.type_id = types.firstObject.id;
    };
    [self.navigationController pushViewController:demandVC animated:true];
}


#pragma mark - IntroduceDemandContactCellDelegate

- (void)introduceDemandContactCell:(IntroduceDemandContactCell *)cell deleteBtn:(UIButton *)deleteBtn
{
    // 从数据源中的指定位置删除一个联系人对象
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (self.demandDetail.contacts.count > 1) {
        [self.demandDetail.contacts removeObjectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}


#pragma mark - IntroduceDemandImagesCellDelegate

- (void)introduceDemandImagesCell:(IntroduceDemandImagesCell *)cell imageView:(UIImageView *)imageView
{
    // 从相册中选择的照片添加到数据源中
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Images *model = [self.demandDetail.images objectAtIndex:indexPath.row];
    model.isPublish = false;
    [self.demandDetail.images replaceObjectAtIndex:indexPath.row withObject:model];

    // 选择的照片添加上传图片数组中
    [self.publishImages replaceObjectAtIndex:indexPath.row withObject:imageView];
}

- (void)introduceDemandImagesCell:(IntroduceDemandImagesCell *)cell deleteBtn:(UIButton *)deleteBtn
{
    // 从数据源中的指定位置删除一个图片对象
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (self.demandDetail.images.count > 1) {
        [self.demandDetail.images removeObjectAtIndex:indexPath.row];
        
        [self.publishImages removeObjectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            IntroduceDemandContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandContactCell];
            NSMutableArray *array = self.dataSource[indexPath.section];
            if (array.count > 1) {
                [contactCell setButtonHidden:false];
            } else {
                [contactCell setButtonHidden:true];
            }
            contactCell.contact = array[indexPath.row];
            contactCell.delegate = self;
            return contactCell;
        }
            break;
        case 2:
        {
            IntroduceDemandDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandDescCell];
            descCell.demandDesc = [self.dataSource[indexPath.section] firstObject];
            return descCell;
        }
            break;
        case 3:
        {
            IntroduceDemandImagesCell *imagesCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandImagesCell];
            NSMutableArray *array = self.dataSource[indexPath.section];
            if (array.count > 1) {
                [imagesCell setButtonHidden:false];
            } else {
                [imagesCell setButtonHidden:true];
            }
            if (self.publishImages.count > 0) {
                imagesCell.introduceImage = self.publishImages[indexPath.row].image;
            }
            imagesCell.publishImage = array[indexPath.row];
            imagesCell.delegate = self;
            return imagesCell;
        }
            break;
        default:
        {
            IntroduceDemandTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:kIntroduceDemandTopCell];
            topCell.topDemand = [self.dataSource[indexPath.section] firstObject];
            topCell.delegate = self;
            return topCell;
        }
            break;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.001;
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return [[UIView alloc] init];
    return [[PGCProjectDetailTagView alloc] initWithTitle:_headerTitles[section]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 3) return 40;
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return [self footerViewTitle:@"添加更多联系人" section:section];
    }
    if (section == 3) {
        return [self footerViewTitle:@"添加更多照片" section:section];
    }
    return [[UIView alloc] init];
}

- (UIView *)footerViewTitle:(NSString *)title section:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"加号"];
    CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:footerBtn];
    footerBtn.tag = section;
    
    footerBtn.bounds = CGRectMake(0, 0, image.size.width + titleSize.width + 30, footerView.height_sd);
    footerBtn.center = footerView.center;
    [footerBtn setImage:image forState:UIControlStateNormal];
    [footerBtn.titleLabel setFont:SetFont(14)];
    [footerBtn setTitle:title forState:UIControlStateNormal];
    [footerBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    footerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    footerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:self.tableView];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = PGCBackColor;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.showsHorizontalScrollIndicator = false;
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 注册表格视图上半部 即 row = 0 的cell
        [_tableView registerClass:[IntroduceDemandTopCell class] forCellReuseIdentifier:kIntroduceDemandTopCell];
        // 注册联系人即 row = 1 的cell
        [_tableView registerClass:[IntroduceDemandContactCell class] forCellReuseIdentifier:kIntroduceDemandContactCell];
        // 注册详细介绍 即 row = 2 的cell
        [_tableView registerClass:[IntroduceDemandDescCell class] forCellReuseIdentifier:kIntroduceDemandDescCell];
        // 注册图片介绍 即 row = 3 的cell
        [_tableView registerClass:[IntroduceDemandImagesCell class] forCellReuseIdentifier:kIntroduceDemandImagesCell];
    }
    return _tableView;
}

- (UIButton *)introduceBtn {
    if (!_introduceBtn) {
        _introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _introduceBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
        _introduceBtn.backgroundColor = PGCTintColor;
        NSString *title = self.demandDetail ? @"重新发布" : @"发布";
        [_introduceBtn setTitle:title forState:UIControlStateNormal];
        [_introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_introduceBtn addTarget:self action:@selector(respondsToIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _introduceBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        if (!self.demandDetail) {
            // 新建一个空白的需求对象
            PGCDemand *demandDetail = [[PGCDemand alloc] init];
            
            // 新建一个空白的联系人数组对象
            NSMutableArray *contacts = [NSMutableArray array];
            // 添加一个空白的联系人对象到数组中
            Contacts *contact = [[Contacts alloc] init];
            [contacts addObject:contact];
            demandDetail.contacts = contacts;
            
            // 新建一个空白的照片数组对象
            NSMutableArray *images = [NSMutableArray array];
            // 添加一个空白的图片对象到数组中
            Images *image = [[Images alloc] init];
            image.isPublish = false;
            [images addObject:image];
            demandDetail.images = images;
            
            [_dataSource insertObject:@[demandDetail] atIndex:0];
            [_dataSource insertObject:demandDetail.contacts atIndex:1];
            [_dataSource insertObject:@[demandDetail] atIndex:2];
            [_dataSource insertObject:demandDetail.images atIndex:3];
            [self.publishImages addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"加照片"]]];
            
            self.demandDetail = demandDetail;
            
        } else {
            [_dataSource insertObject:@[self.demandDetail] atIndex:0];
            [_dataSource insertObject:self.demandDetail.contacts atIndex:1];
            [_dataSource insertObject:@[self.demandDetail] atIndex:2];
            
            for (Images *image in self.demandDetail.images) {
                NSString *string = [kBaseImageURL stringByAppendingString:image.image];
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
                [self.publishImages addObject:imageView];
                image.isPublish = true;
                [_dataSource insertObject:self.demandDetail.images atIndex:3];
            }
        }
    }
    return _dataSource;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (NSMutableArray<UIImageView *> *)publishImages {
    if (!_publishImages) {
        _publishImages = [NSMutableArray array];
    }
    return _publishImages;
}

@end
