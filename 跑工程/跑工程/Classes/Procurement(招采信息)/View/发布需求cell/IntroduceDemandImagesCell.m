//
//  IntroduceDemandImagesCell.m
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "IntroduceDemandImagesCell.h"
#import "PGCOtherAPIManager.h"
#import "Images.h"

@interface IntroduceDemandImagesCell () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImageView *publishImageView;/** 图片添加视图 */
@property (strong, nonatomic) UITextField *descTextField;/** 图片介绍输入框 */
@property (strong, nonatomic) UIButton *deleteButton;/** 右上角删除按钮 */
@property (strong, nonatomic) UIView *line;/** 分割线 */
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation IntroduceDemandImagesCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIImage *image = [UIImage imageNamed:@"删除"];
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.backgroundColor = [UIColor clearColor];
    [self.deleteButton setImage:image forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    self.deleteButton.sd_layout
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(20)
    .widthIs(40);
    self.deleteButton.hidden = true;
    
    
    CGFloat height = (SCREEN_WIDTH - 60) / 4 + 10;
    // 图片添加视图
    self.publishImageView = [[UIImageView alloc] init];
    self.publishImageView.image = [UIImage imageNamed:@"加照片"];
    self.publishImageView.userInteractionEnabled = true;
    [self.contentView addSubview:self.publishImageView];
    [self.publishImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageTap:)]];
    self.publishImageView.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(height)
    .heightIs(height);
    
    // 图片介绍输入框
    self.descTextField = [[UITextField alloc] init];
    self.descTextField.layer.borderWidth = 0.5;
    self.descTextField.layer.borderColor = PGCBackColor.CGColor;
    self.descTextField.layer.masksToBounds = true;
    self.descTextField.placeholder = @"请输入图片介绍";
    self.descTextField.textColor = RGB(51, 51, 51);
    self.descTextField.font = SetFont(14);
    self.descTextField.delegate = self;
    [self.contentView addSubview:self.descTextField];
    self.descTextField.sd_layout
    .topSpaceToView(self.publishImageView, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(30);
    
    // 底部分割线
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:self.line];
    self.line.sd_layout
    .topSpaceToView(self.descTextField, 5)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:self.line bottomMargin:0];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.publishImage.imageDec = textField.text.length > 0 ? textField.text : @"";
}


#pragma mark - Gesture

- (void)addImageTap:(UITapGestureRecognizer *)gesture
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传图片：" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectPhotoAlbumPhotos];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takingPictures];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [PGCkeyWindow.rootViewController presentViewController:alert animated:true completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = nil;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
            image = info[UIImagePickerControllerOriginalImage];
        }
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        image = info[UIImagePickerControllerEditedImage];
    }
    self.introduceImage = image;
    
    [picker dismissViewControllerAnimated:true completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceDemandImagesCell:imageView:)]) {
        [self.delegate introduceDemandImagesCell:self imageView:self.publishImageView];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - UIAlertControllerStyleActionSheet
// 相册
- (void)selectPhotoAlbumPhotos {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.mediaTypes = @[mediaTypes[0]];
        self.imagePickerController.allowsEditing = true;
        
        [PGCkeyWindow.rootViewController presentViewController:self.imagePickerController animated:true completion:nil];
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
        
        [PGCkeyWindow.rootViewController presentViewController:self.imagePickerController animated:true completion:nil];
    } else {
        [PGCProgressHUD showAlertWithTarget:self title:@"温馨提示：" message:@"当前设备不支持拍照！" actionWithTitle:@"我知道了" handler:^(UIAlertAction *action) {
        }];
    }
}


#pragma mark - Event

- (void)deleteBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceDemandImagesCell:deleteBtn:)]) {
        [self.delegate introduceDemandImagesCell:self deleteBtn:sender];
    }
}


#pragma mark - Setter

- (void)setIntroduceImage:(UIImage *)introduceImage
{
    _introduceImage = introduceImage;
    
    self.publishImageView.image = introduceImage ? introduceImage : [UIImage imageNamed:@"加照片"];
}

- (void)setPublishImage:(Images *)publishImage
{
    _publishImage = publishImage;
    
    if (publishImage.image) {
        NSString *string = [kBaseImageURL stringByAppendingString:publishImage.image];
        [self.publishImageView sd_setImageWithURL:[NSURL URLWithString:string]];
    }
    self.descTextField.text = publishImage.imageDec ? publishImage.imageDec : @"";
}


#pragma mark - Getter

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.navigationBar.barTintColor = PGCTintColor;
        _imagePickerController.navigationBar.tintColor = [UIColor whiteColor];
        _imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        _imagePickerController.navigationBar.translucent = true;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}


#pragma mark - Public

- (void)setButtonHidden:(BOOL)hidden
{
    self.deleteButton.hidden = hidden;
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
