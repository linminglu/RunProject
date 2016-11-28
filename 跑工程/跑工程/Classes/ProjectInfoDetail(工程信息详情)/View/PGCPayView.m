//
//  PGCPayView.m
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCPayView.h"
#import "NSString+Size.h"

@interface PGCPayView ()

@property (strong, nonatomic) UIView *backView;

@end

@implementation PGCPayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithSuccessPay
{
    self = [super init];
    if (self) {
        
        [self setupSubviewsWithSuccessPay];
    }
    return self;
}

/**
 支付成功子视图布局
 */
- (void)setupSubviewsWithSuccessPay {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.4, SCREEN_WIDTH * 0.4);
    self.center = CGPointMake(KeyWindow.centerX_sd, KeyWindow.centerY_sd - 25);
    self.backgroundColor = RGB(244, 244, 244);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, self.width_sd / 3, self.width_sd / 3);
    imageView.center = CGPointMake(self.width_sd / 2, self.height_sd / 2 - 10);
    imageView.image = [UIImage imageNamed:@"支付成功"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom_sd + 15, self.width_sd, 30)];
    label.text = @"支付成功";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = PGCTintColor;
    label.font = SetFont(15);
    [self addSubview:label];
}

/**
 三方支付按钮子视图布局
 */
- (void)setupSubviews {
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH / 2);
    self.backgroundColor = [UIColor whiteColor];
    
    // 选择支付方式标签
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = PGCTintColor;
    label.text = @"选择支付方式";
    label.font = SetFont(17);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(50);
    
    // 删除按钮图片
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(respondsToPayCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    deleteBtn.sd_layout
    .centerYEqualToView(label)
    .rightSpaceToView(self, 10)
    .heightIs(40)
    .widthIs(40);
    
    // 分割线
    UIView *lineViewW = [[UIView alloc] init];
    lineViewW.backgroundColor = RGB(244, 244, 244);
    [self addSubview:lineViewW];
    lineViewW.sd_layout
    .topSpaceToView(label, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    // 微信支付按钮
    UIButton *weChatBtn = [[UIButton alloc] init];
    UIImage *weChatImage = [UIImage imageNamed:@"微信_icon"];
    [weChatBtn setImage:weChatImage forState:UIControlStateNormal];
    [weChatBtn addTarget:self action:@selector(respondsToWeChatPay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weChatBtn];
    weChatBtn.sd_layout
    .topSpaceToView(lineViewW, 20)
    .centerXIs(self.width / 4)
    .heightIs(weChatImage.size.height)
    .widthEqualToHeight();
    
    UILabel *weChatLabel = [[UILabel alloc] init];
    weChatLabel.text = @"微信支付";
    weChatLabel.textColor = RGB(102, 102, 102);
    weChatLabel.textAlignment = NSTextAlignmentCenter;
    weChatLabel.font = SetFont(14);
    [self addSubview:weChatLabel];
    weChatLabel.sd_layout
    .centerXEqualToView(weChatBtn)
    .topSpaceToView(weChatBtn, 5)
    .widthRatioToView(weChatBtn, 2.0)
    .heightIs(30);
    
    // 微信和支付宝之间的分割线
    UIView *lineViewH = [[UIView alloc] init];
    lineViewH.backgroundColor = RGB(244, 244, 244);
    [self addSubview:lineViewH];
    lineViewH.sd_layout
    .topSpaceToView(lineViewW, 0)
    .centerXEqualToView(self)
    .bottomSpaceToView(self, 0)
    .widthIs(1);
    
    // 支付宝支付按钮
    UIButton *alipayBtn = [[UIButton alloc] init];
    UIImage *alipayImage = [UIImage imageNamed:@"支付宝_icon"];
    [alipayBtn setImage:alipayImage forState:UIControlStateNormal];
    [alipayBtn addTarget:self action:@selector(respondsToAlipay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:alipayBtn];
    alipayBtn.sd_layout
    .topSpaceToView(lineViewW, 20)
    .centerXIs(self.width * 3 / 4)
    .heightIs(alipayImage.size.height)
    .widthEqualToHeight();
    
    UILabel *alipayLabel = [[UILabel alloc] init];
    alipayLabel.text = @"支付宝支付";
    alipayLabel.textColor = RGB(102, 102, 102);
    alipayLabel.textAlignment = NSTextAlignmentCenter;
    alipayLabel.font = SetFont(14);
    [self addSubview:alipayLabel];
    alipayLabel.sd_layout
    .centerXEqualToView(alipayBtn)
    .topSpaceToView(alipayBtn, 5)
    .widthRatioToView(alipayBtn, 2.0)
    .heightIs(30);
}


#pragma mark - Events

- (void)respondsToPayCancel:(UIButton *)sender {
    [self hidePayView];
}

- (void)respondsToWeChatPay:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payView:weChat:)]) {
        [self.delegate payView:self weChat:sender];
    }
    [self hidePayView];
}

- (void)respondsToAlipay:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payView:alipay:)]) {
        [self.delegate payView:self alipay:sender];
    }
    [self hidePayView];
}

#pragma mark - Public

- (void)showPayView {
    [UIView animateWithDuration:0.25f animations:^{
        [KeyWindow addSubview:self.backView];
        [KeyWindow addSubview:self];
        
        self.backView.alpha = 0.3;
        self.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH / 2);
    }];
}

- (void)showPayViewWithGCD {
    [UIView animateWithDuration:0.25f animations:^{
        [KeyWindow addSubview:self.backView];
        [KeyWindow addSubview:self];
        
        self.backView.alpha = 0.3;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidePaySucceedView];
    });
}


#pragma mark - Private

- (void)hidePayView {
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.alpha = 0;
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH / 2);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

- (void)hidePaySucceedView {
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.alpha = 0;
        
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        
        [self.backView removeFromSuperview];
    }];
}


#pragma mark - Gesture

- (void)respondsToBackViewGesture:(UITapGestureRecognizer *)gesture {
    [self hidePayView];
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
