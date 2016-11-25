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

@interface IntroduceDemandImagesCell () <UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *publishImageView;/** 图片添加视图 */
@property (strong, nonatomic) UITextField *descTextField;/** 图片介绍输入框 */
@property (strong, nonatomic) UIButton *deleteButton;/** 右上角删除按钮 */
@property (strong, nonatomic) UIView *line;/** 分割线 */

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
    if (textField.text.length > 0) {
        self.publishImage.imageDec = textField.text;
    }
}


#pragma mark - Gesture

- (void)addImageTap:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(introduceDemandImagesCell:addImage:)]) {
        [self.delegate introduceDemandImagesCell:self addImage:gesture];
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

- (void)setPublishImage:(Images *)publishImage
{
    _publishImage = publishImage;
    
    if (publishImage.image) {
        NSString *string = [kBaseImageURL stringByAppendingString:publishImage.image];
        [self.publishImageView sd_setImageWithURL:[NSURL URLWithString:string]];
    }
    self.descTextField.text = publishImage.imageDec ? publishImage.imageDec : @"";
    
}


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
