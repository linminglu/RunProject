//
//  PGCUserInfoController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCUserInfoController.h"
#import "PGCChooseJobController.h"
#import "PGCChooseCompanyController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PGCProfileAPIManager.h"
#import "PGCTokenManager.h"
#import "PGCUserInfo.h"

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

- (void)initializeDataSource {
    PGCTokenManager *manager = [PGCTokenManager tokenManager];
    [manager readAuthorizeData];
    PGCUserInfo *user = manager.token.user;
    
    [self.iconBtn setImage:[UIImage imageNamed:user.headimage] forState:UIControlStateNormal];
    self.nameLabel.text = user.name;
    if (user.sex == 1) {
        self.sexLabel.text = @"男";
    } else {
        self.sexLabel.text = @"女";
    }
    self.phoneLabel.text = user.phone;
    self.jobLabel.text = user.post;
    self.companyLabel.text = user.company;
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"个人资料";
    
    self.iconBtn.layer.masksToBounds = true;
    self.iconBtn.layer.cornerRadius = 25.0;
    self.iconBtn.layer.borderWidth = 1.0;
    self.iconBtn.layer.borderColor = RGB(239, 239, 241).CGColor;
}

#pragma mark - Events
// 选择头像
- (IBAction)iconBtnClick:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoAlbumPhotos];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takingPictures];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

// 选择性别
- (IBAction)sexBtnClick:(UIButton *)sender {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLabel.text = @"男";
        
        [self.parameters setObject:@(1) forKey:@"sex"];
        
        [PGCProfileAPIManager completeInfoRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            
        }];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLabel.text = @"女";
        
        [self.parameters setObject:@(0) forKey:@"sex"];
        
        [PGCProfileAPIManager completeInfoRequestWithParameters:self.parameters responds:^(RespondsStatus status, NSString *message, id resultData) {
            
        }];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertView animated:true completion:nil];
}

//选择职位
- (IBAction)jobBtnClick:(UIButton *)sender {
    __weak PGCUserInfoController *weakSelf = self;
    PGCChooseJobController *jobVC = [[PGCChooseJobController alloc] init];
    jobVC.block = ^(NSString *job) {
        weakSelf.jobLabel.text = job;
    };
    [self.navigationController pushViewController:jobVC animated:true];
}

/***
//选择公司
- (IBAction)chooseCompanyBtnClick:(id)sender {
    
    if ([self.companyLabel.text isEqualToString:@"未填写"]) {
        __weak PGCUserInfoController *weakSelf = self;
        PGCChooseCompanyController *companyVC = [[PGCChooseCompanyController alloc] init];
        
        companyVC.block = ^(NSString *job) {
            weakSelf.companyLabel.text = job;
        };
        [self.navigationController pushViewController:companyVC animated:YES];
    }
}
***/


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
    
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
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
        [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示:" message:@"当前设备不支持拍照！" actionWithTitle:@"确定" handler:^{
        }];
    }
}


#pragma mark - Getter

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setObject:@"iphone" forKey:@"client_type"];
        [_parameters setObject:[PGCTokenManager tokenManager].token.token forKey:@"token"];
        [_parameters setObject:@([PGCTokenManager tokenManager].token.user.id) forKey:@"user_id"];
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
