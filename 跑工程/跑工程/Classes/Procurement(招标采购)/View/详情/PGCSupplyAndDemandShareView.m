//
//  PGCSupplyAndDemandShareView.m
//  跑工程
//
//  Created by leco on 2016/11/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSupplyAndDemandShareView.h"

#define ShareBtnTag 74

@interface PGCSupplyAndDemandShareView ()

@property (strong, nonatomic) UIView *backView;

@end

@implementation PGCSupplyAndDemandShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH / 2);
    self.backgroundColor = [UIColor whiteColor];
    
    // 分享到标签
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = PGCTextColor;
    label.text = @"分享到";
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
    [deleteBtn addTarget:self action:@selector(respondsToShareCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    deleteBtn.sd_layout
    .centerYEqualToView(label)
    .rightSpaceToView(self, 10)
    .heightIs(40)
    .widthIs(40);
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(244, 244, 244);
    [self addSubview:line];
    line.sd_layout
    .topSpaceToView(label, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    
    UIView *tempView = nil;
    NSArray *imageNames = @[@"QQ好友", @"QQ空间", @"微信好友", @"朋友圈"];
    for (int i = 0; i < imageNames.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view.sd_layout
        .leftSpaceToView(self, i * (SCREEN_WIDTH / 4))
        .topSpaceToView(line, 0)
        .widthRatioToView(self, 0.25)
        .bottomSpaceToView(self, 0);
        
        UIImage *image = [UIImage imageNamed:imageNames[i]];
        UIButton *button = [[UIButton alloc] init];
        button.tag = ShareBtnTag + i;
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(respondsToShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        button.sd_layout
        .centerXIs(SCREEN_WIDTH / 8)
        .centerYIs(SCREEN_WIDTH / 8 - 5)
        .heightIs(image.size.height)
        .widthEqualToHeight();
        
        UILabel *label = [[UILabel alloc] init];
        label.text = imageNames[i] ;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGB(102, 102, 102);
        label.font = SetFont(12);
        [view addSubview:label];
        label.sd_layout
        .leftSpaceToView(view, 5)
        .rightSpaceToView(view, 5)
        .topSpaceToView(button, 15)
        .autoHeightRatio(0);
        
        if (i == imageNames.count - 1) {
            tempView = view;
        }
    }
    [self setupAutoHeightWithBottomView:tempView bottomMargin:0];
}


#pragma mark - Events

- (void)respondsToShareCancel:(UIButton *)sender {
    [self hideShareView];
}

- (void)respondsToShareButton:(UIButton *)sender {
    switch (sender.tag) {
        case ShareBtnTag:
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:qqFriend:)]) {
                [self.delegate shareView:self qqFriend:sender];
            }
            break;
        case ShareBtnTag + 1:
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:qqZone:)]) {
                [self.delegate shareView:self qqZone:sender];
            }
            break;
        case ShareBtnTag + 2:
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:weChat:)]) {
                [self.delegate shareView:self weChat:sender];
            }
            break;
        case ShareBtnTag + 3:
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:weChatFriends:)]) {
                [self.delegate shareView:self weChatFriends:sender];
            }
            break;
        default:
            break;
    }
    [self hideShareView];
}


#pragma mark - Public

- (void)showShareView {
    [UIView animateWithDuration:0.25f animations:^{
        [KeyWindow addSubview:self.backView];
        [KeyWindow addSubview:self];
        
        self.backView.alpha = 0.7;
        self.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH / 2);
    }];
}


#pragma mark - Private

- (void)hideShareView {
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.alpha = 0;
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH / 2);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}


#pragma mark - Gesture

- (void)respondsToBackViewGesture:(UITapGestureRecognizer *)gesture {
    [self hideShareView];
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
