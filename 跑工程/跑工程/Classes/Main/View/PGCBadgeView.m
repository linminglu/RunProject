//
//  PGCBadgeView.m
//  跑工程
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCBadgeView.h"

@implementation PGCBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = false;
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        // 设置字体大小
        self.titleLabel.font = SetFont(11);
        [self sizeToFit];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
    // 判断badgeValue是否有内容
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) { // 没有内容或者空字符串,等于0
        self.hidden = true;
    }else{
        self.hidden = false;
        _badgeValue = badgeValue;
    }
    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:SetFont(11)}];
    if (size.width > self.frame.size.width) {// 文字的尺寸大于控件的宽度
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else {
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
}


@end
