//
//  IntroduceDemandImagesCell.m
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "IntroduceDemandImagesCell.h"

@interface IntroduceDemandImagesCell () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;


@end

@implementation IntroduceDemandImagesCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)createUI
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectPhotoAlbumPhotos];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takingPictures];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [KeyWindow.rootViewController presentViewController:alert animated:true completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = nil;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
            image = info[UIImagePickerControllerOriginalImage];
            [self.publishImages addObject:image];
        }
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        image = info[UIImagePickerControllerEditedImage];
        [self.publishImages addObject:image];
        
    }
    
    
    [KeyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [KeyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - UIAlertControllerStyleActionSheet
// 相册
- (void)selectPhotoAlbumPhotos {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.mediaTypes = @[mediaTypes[0]];
        self.imagePickerController.allowsEditing = true;
        
        [KeyWindow.rootViewController presentViewController:self.imagePickerController animated:true completion:nil];
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
        
        [KeyWindow.rootViewController presentViewController:self.imagePickerController animated:true completion:nil];
    } else {
        [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"当前设备不支持拍照！" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
        }];
    }
}


#pragma mark - Setter

- (void)setPublishImages:(NSMutableArray *)publishImages
{
    _publishImages = publishImages;
    
//            NSArray *images = self.demandDetail.images;
//            for (Images *image in images) {
//                NSString *string = [image.image substringFromIndex:3];
//                NSString *url = [kBaseImageURL stringByAppendingString:string];
//            }
    if (!publishImages) {
        _publishImages = [NSMutableArray array];
        return;
    }
    
}


#pragma mark - Getter

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.navigationBar.barTintColor = [UIColor whiteColor];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
