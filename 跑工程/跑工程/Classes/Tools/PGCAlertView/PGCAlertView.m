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

- (void)setupSubviewsWithTitle:(NSString *)title {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.35);
    self.center = CGPointMake(PGCKeyWindow.centerX, PGCKeyWindow.centerY - self.height/2);
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
    line.backgroundColor = PGCThemeColor;
    [self addSubview:line];
    line.sd_layout
    .topSpaceToView(_imageBtn, 10)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1.5);
    
    UIButton *delete = [[UIButton alloc] init];
    delete.backgroundColor = [UIColor whiteColor];
    [delete.titleLabel setFont:SetFont(15)];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(respondsToDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delete];
    delete.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(self, 0)
    .widthRatioToView(self, 0.5)
    .heightIs(40);
    
    UIButton *confirm = [[UIButton alloc] init];
    confirm.backgroundColor = PGCThemeColor;
    [confirm.titleLabel setFont:SetFont(15)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(respondsToConfirm:) forControlEvents:UIControlEventTouchUpInside];
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
        [PGCKeyWindow addSubview:self.backView];
        [PGCKeyWindow addSubview:self];
        
        self.backView.alpha = 0.7;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAlertViewWithBlock:(PGCAlertViewBlock)block {
    [UIView animateWithDuration:0.25f animations:^{
        [PGCKeyWindow addSubview:self.backView];
        [PGCKeyWindow addSubview:self];
        
        self.backView.alpha = 0.7;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.block = block;
    }];
}


#pragma mark - Private

- (void)hideAlertView {
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

- (void)hideAlertViewWithBlock:(PGCAlertViewBlock)block {
    dispatch_after(0.1f, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.backView.alpha = 0;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            [self.backView removeFromSuperview];
        }];
    });
}


#pragma mark - Events

- (void)respondsToDelete:(UIButton *)sender {
    [self hideAlertView];
}

- (void)respondsToConfirm:(UIButton *)sender {
    [self hideAlertView];
}


#pragma mark - Gesture

- (void)respondsToBackViewGesture:(UITapGestureRecognizer *)gesture {
    [self hideAlertView];
}

- (void)respondsToImageButton:(UIButton *)sender {
    sender.selected = !sender.selected;
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
