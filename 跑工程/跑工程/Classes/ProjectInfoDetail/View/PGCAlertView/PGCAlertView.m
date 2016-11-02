//
//  PGCAlertView.m
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAlertView.h"

@interface PGCAlertView ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIButton *imageBtn;

@end

@implementation PGCAlertView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        [self setupSubviewsWithTitle:title];
    }
    return self;
}

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        
        [self setupSubviewsWithModel:model];
    }
    return self;
}


- (void)setupSubviewsWithModel:(id)model {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.35);
    self.center = CGPointMake(KeyWindow.centerX, KeyWindow.centerY - 25);
    self.backgroundColor = RGB(244, 244, 244);
    
    // 联系人标签
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textColor = PGCTintColor;
    nameLabel.text = model[@"name"];
    nameLabel.font = SetFont(15);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    nameLabel.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 0)
    .widthRatioToView(self, 1)
    .heightIs(40);
    
    // 呼叫按钮
    UIButton *phoneBtn = [[UIButton alloc] init];
    phoneBtn.backgroundColor = [UIColor whiteColor];
    [phoneBtn.titleLabel setFont:SetFont(15)];
    [phoneBtn setTitle:model[@"phone"] forState:UIControlStateNormal];
    [phoneBtn setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(respondsToAlertPhone:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    phoneBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(nameLabel, 1)
    .widthRatioToView(self, 1)
    .heightIs(40);
    
    // 添加到联系人按钮
    UIButton *addToContactBtn = [[UIButton alloc] init];
    addToContactBtn.backgroundColor = [UIColor whiteColor];
    [addToContactBtn.titleLabel setFont:SetFont(15)];
    [addToContactBtn setTitle:@"添加到联系人"forState:UIControlStateNormal];
    [addToContactBtn setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [addToContactBtn addTarget:self action:@selector(respondsToAlertAddContact:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addToContactBtn];
    addToContactBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(phoneBtn, 1)
    .widthRatioToView(self, 1)
    .heightIs(40);
    
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn.titleLabel setFont:SetFont(15)];
    [cancelBtn setTitle:@"取消"forState:UIControlStateNormal];
    [cancelBtn setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(respondsToAlertCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    cancelBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(addToContactBtn, 1)
    .widthRatioToView(self, 1)
    .heightIs(40);
    
    [self setupAutoHeightWithBottomView:cancelBtn bottomMargin:0];
}


- (void)setupSubviewsWithTitle:(NSString *)title {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.35);
    self.center = CGPointMake(KeyWindow.centerX, KeyWindow.centerY - 25);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = PGCTextColor;
    titleLabel.text = title;
    titleLabel.font = SetFont(13);
    [self addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(self, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
    
    _imageBtn = [[UIButton alloc] init];
    [_imageBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [_imageBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [_imageBtn addTarget:self action:@selector(respondsToImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_imageBtn];
    UIImage *image = [UIImage imageNamed:@"未选中"];
    _imageBtn.sd_layout
    .topSpaceToView(titleLabel, 10)
    .leftSpaceToView(self, 15)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
    
    UILabel *noRemindLabel = [[UILabel alloc] init];
    noRemindLabel.textColor = PGCTextColor;
    noRemindLabel.text = @"不再提示";
    noRemindLabel.font = SetFont(14);
    [self addSubview:noRemindLabel];
    noRemindLabel.sd_layout
    .centerYEqualToView(_imageBtn)
    .leftSpaceToView(_imageBtn, 8)
    .rightSpaceToView(self, 0)
    .autoHeightRatio(0);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = PGCTintColor;
    [self addSubview:line];
    line.sd_layout
    .topSpaceToView(_imageBtn, 10)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    UIButton *delete = [[UIButton alloc] init];
    delete.backgroundColor = [UIColor whiteColor];
    [delete.titleLabel setFont:SetFont(15)];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(respondsToAlertDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delete];
    delete.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(self, 0)
    .widthRatioToView(self, 0.5)
    .heightIs(40);
    
    UIButton *confirm = [[UIButton alloc] init];
    confirm.backgroundColor = PGCTintColor;
    [confirm.titleLabel setFont:SetFont(15)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(respondsToAlertConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm];
    confirm.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(delete, 0)
    .widthRatioToView(self, 0.5)
    .heightIs(40);
    
    [self setupAutoHeightWithBottomViewsArray:@[delete, confirm] bottomMargin:0];
}


#pragma mark - Public

- (void)showAlertView {
    [UIView animateWithDuration:0.25f animations:^{
        [KeyWindow addSubview:self.backView];
        [KeyWindow addSubview:self];
        
        self.backView.alpha = 0.7;
    }];
}


#pragma mark - Private

- (void)hideAlertView {
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.alpha = 0;
        
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        
        [self.backView removeFromSuperview];
    }];
}


#pragma mark - Events

- (void)respondsToAlertCancel:(UIButton *)sender {
    [self hideAlertView];
}

- (void)respondsToAlertDelete:(UIButton *)sender {
    [self hideAlertView];
}

- (void)respondsToAlertConfirm:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:confirm:)]) {
        [self.delegate alertView:self confirm:sender];
    }
    
    [self hideAlertView];
}

- (void)respondsToAlertPhone:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:phone:)]) {
        [self.delegate alertView:self phone:sender];
    }
    
    [self hideAlertView];
}

- (void)respondsToAlertAddContact:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:addContact:)]) {
        [self.delegate alertView:self addContact:sender];
    }
    
    [self hideAlertView];
}

- (void)respondsToImageButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}


#pragma mark - Gesture

- (void)respondsToBackViewGesture:(UITapGestureRecognizer *)gesture {
    [self hideAlertView];
}


#pragma mark - Getter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0;
        
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBackViewGesture:)]];
    }
    return _backView;
}

@end
