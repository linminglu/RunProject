//
//  PGCUserInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCUserInfoController.h"
#import "PGCChooseJobController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PGCLoginController.h"
#import "PGCRegisterOrLoginAPIManager.h"
#import "PGCProfileAPIManager.h"
#import "PGCHeadImage.h"
#import "PGCNetworkHelper.h"

@interface PGCUserInfoController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;/** 头像 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;/** 性别 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;/** 手机 */
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;/** 职位 */
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;/** 公司 */
@property (strong, nonatomic) NSMutableDictionary *parameters;/** 上传参数 */
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    // 用户头像
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:user.headimage]];
    [self.iconBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    // 用户名
    self.nameLabel.text = user.name;
    // 性别
    if (user.sex == 1) {
        self.sexLabel.text = @"男";
    } else {
        self.sexLabel.text = @"女";
    }
    self.phoneLabel.text = user.phone;
    self.jobLabel.text = user.post ? user.post : @"未填写";
    self.companyLabel.text = user.company;
}  

- (void)initializeUserInterface
{
    self.navigationItem.title = @"个人资料";
    
    self.iconBtn.layer.masksToBounds = true;
    self.iconBtn.layer.cornerRadius = 25.0;
    self.iconBtn.layer.borderWidth = 1.0;
    self.iconBtn.layer.borderColor = RGB(239, 239, 241).CGColor;
}


- (void)updateSession
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    NSDictionary *params = @{@"user_id":@(user.user_id),
                             @"client_type":@"iphone",
                             @"token":manager.token.token};
    // 更新用户session
    [PGCRegisterOrLoginAPIManager updateSessionRequestWithParameters:params responds:^(RespondsStatus status, NSString *message, id resultData) {
        if (status != RespondsStatusSuccess) {
            [PGCProgressHUD showAlertWithTarget:self title:message];
        }
    }];
}

#pragma mark - Events
// 选择头像
- (IBAction)iconBtnClick:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectPhotoAlbumPhotos];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takingPictures];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

// 选择性别
- (IBAction)sexBtnClick:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.parameters setObject:@(1) forKey:@"sex"];        
        [PGCProfileAPIManager completeInfoRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                self.sexLabel.text = @"男";
            } else {
                [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                    
                }];
            }
        }];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.parameters setObject:@(0) forKey:@"sex"];
        [PGCProfileAPIManager completeInfoRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            if (status == RespondsStatusSuccess) {
                self.sexLabel.text = @"女";
            } else {
                [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                    
                }];
            }
        }];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertView animated:true completion:nil];
}

//选择职位
- (IBAction)jobBtnClick:(UIButton *)sender
{
    __weak PGCUserInfoController *weakSelf = self;
    PGCChooseJobController *jobVC = [[PGCChooseJobController alloc] init];
    jobVC.parameters = self.parameters;
    jobVC.block = ^(NSString *job) {
        weakSelf.jobLabel.text = job;
    };
    [self.navigationController pushViewController:jobVC animated:true];
}

- (void)showAlertSheetWithTitle:(NSString *)string
                     otherTitle:(NSString *)otherString
                        handler:(void (^ __nullable)(UIAlertAction *action))handler
                   otherHandler:(void (^ __nullable)(UIAlertAction *action))otherHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:otherString style:UIAlertActionStyleDefault handler:otherHandler]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = nil;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
            [self.iconBtn setImage:info[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
            image = info[UIImagePickerControllerOriginalImage];
        }
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        [self.iconBtn setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        image = info[UIImagePickerControllerEditedImage];
    }
    
    NSDictionary *params = @{@"clientType":@"user",
                             @"category":@"1000",
                             @"limit":@"false",
                             @"width":@"200",
                             @"height":@"200"};
    NSString *jsonStr = [PGCBaseAPIManager jsonToString:params];
    
    [PGCProfileAPIManager uploadHeadImageRequestWithParameters:@{@"jsonStr":jsonStr} image:image responds:^(RespondsStatus status, NSString *message, id resultData) {
        
        if (status == RespondsStatusSuccess) {
            [PGCProgressHUD showAlertWithTarget:self title:@"头像上传成功！"];
            [PGCNotificationCenter postNotificationName:kReloadProfileInfo object:nil userInfo:@{@"HeadImage":resultData}];
        } else {
            [PGCProgressHUD showAlertWithTarget:self title:@"头像上传失败：" message:message actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
                
            }];
        }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentedViewController dismissViewControllerAnimated:true completion:nil];
}



#pragma mark - UIAlertControllerStyleActionSheet
// 相册
- (void)selectPhotoAlbumPhotos {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.mediaTypes = @[mediaTypes[0]];
        self.imagePickerController.allowsEditing = true;
        
        [self presentViewController:self.imagePickerController animated:true completion:nil];
    }
}

// 拍照
- (void)takingPictures {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.mediaTypes = @[mediaTypes[0]];
        self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController:self.imagePickerController animated:true completion:nil];
    } else {
        [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"当前设备不支持拍照！" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {            
        }];
    }
}


#pragma mark - Getter

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
        
        PGCManager *manager = [PGCManager manager];
        [manager readTokenData];
        PGCUser *user = manager.token.user;
        [_parameters setObject:@"iphone" forKey:@"client_type"];
        [_parameters setObject:manager.token.token forKey:@"token"];
        [_parameters setObject:@(user.user_id) forKey:@"user_id"];
    }
    return _parameters;
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.navigationBar.barTintColor = [UIColor whiteColor];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}


@end
