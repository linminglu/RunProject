//
//  PGCHintAlertView.m
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCHintAlertView.h"

@interface PGCHintAlertView ()

@property (strong, nonatomic) UIView *backView;

@end

@implementation PGCHintAlertView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        [self setupSubviewsWithTitle:title];
    }
    return self;
}

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        
        [self setupSubviewsWithContent:content];
    }
    return self;
}

- (void)setupSubviewsWithContent:(NSString *)content {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.35);
    self.center = CGPointMake(KeyWindow.centerX, KeyWindow.centerY - 25);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = PGCTintColor;
    titleLabel.text = @"保存成功";
    titleLabel.font = SetFont(15);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(self, 0)
    .centerXEqualToView(self)
    .widthRatioToView(self, 1)
    .heightIs(40);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line];
    line.sd_layout
    .topSpaceToView(titleLabel, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:centerView];
    centerView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(line, 0)
    .heightRatioToView(self, 0.6);
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = PGCTextColor;
    contentLabel.text = content;
    contentLabel.font = SetFont(13);
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:contentLabel];
    contentLabel.sd_layout
    .centerYEqualToView(centerView)
    .centerXEqualToView(centerView)
    .widthRatioToView(centerView, 0.9)
    .autoHeightRatio(0);
    
    UIButton *okButton = [[UIButton alloc] init];
    okButton.backgroundColor = PGCTintColor;
    [okButton.titleLabel setFont:SetFont(15)];
    [okButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(respondsToHintAlertKnown:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okButton];
    okButton.sd_layout
    .topSpaceToView(centerView, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    [self setupAutoHeightWithBottomView:okButton bottomMargin:0];

}

- (void)setupSubviewsWithTitle:(NSString *)title
{
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.35);
    self.center = CGPointMake(KeyWindow.centerX, KeyWindow.centerY - 25);
    self.backgroundColor = RGB(244, 244, 244);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = PGCTintColor;
    titleLabel.text = @"提示";
    titleLabel.font = SetFont(15);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(self, 0)
    .centerXEqualToView(self)
    .widthRatioToView(self, 1)
    .heightIs(40);
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor whiteColor];
    contentLabel.textColor = PGCTextColor;
    contentLabel.text = title;
    contentLabel.font = SetFont(13);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    contentLabel.sd_layout
    .topSpaceToView(titleLabel, 1)
    .centerXEqualToView(self)
    .widthRatioToView(self, 1)
    .heightRatioToView(self, 0.5);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = PGCTintColor;
    [self addSubview:line];
    line.sd_layout
    .topSpaceToView(contentLabel, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    UIButton *cancel = [[UIButton alloc] init];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel.titleLabel setFont:SetFont(15)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:PGCTextColor forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(respondsToHintAlertDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    cancel.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(self, 0)
    .widthRatioToView(self, 0.5)
    .heightIs(40);
    
    UIButton *confirm = [[UIButton alloc] init];
    confirm.backgroundColor = PGCTintColor;
    [confirm.titleLabel setFont:SetFont(15)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(respondsToHintAlertConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm];
    confirm.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(cancel, 0)
    .widthRatioToView(self, 0.5)
    .heightIs(40);
    
    [self setupAutoHeightWithBottomViewsArray:@[cancel, confirm] bottomMargin:0];
}


#pragma mark - Public

- (void)showHintAlertView {
    [UIView animateWithDuration:0.25f animations:^{
        [KeyWindow addSubview:self.backView];
        [KeyWindow addSubview:self];
        
        self.backView.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - Events

- (void)respondsToHintAlertDelete:(UIButton *)sender {
    [self hideAlertView];
}


- (void)respondsToHintAlertConfirm:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hintAlertView:confirm:)]) {
        [self.delegate hintAlertView:self confirm:sender];
    }
    [self hideAlertView];
}


- (void)respondsToHintAlertKnown:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hintAlertView:known:)]) {
        [self.delegate hintAlertView:self known:sender];
    }
    [self hideAlertView];
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
