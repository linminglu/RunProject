//
//  PhotoProgressView.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhotoProgressView.h"

@interface PhotoProgressView ()

@property (strong, nonatomic) UILabel *pct;
@property (strong, nonatomic) UIImageView *animation;

@end

@implementation PhotoProgressView

- (void)dealloc
{
    [_animation.layer removeAnimationForKey:@"rotationAnimation"];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.4]];
        
        _animation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _animation.center = self.center;
        [_animation setImage:[UIImage imageNamed:@"dialog_load"]];
        [self addSubview:_animation];
        
        _pct = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35,90)];
        [_pct setTextAlignment:NSTextAlignmentCenter];
        [_pct setTextColor:[UIColor whiteColor]];
        [_pct setFont:[UIFont systemFontOfSize:9]];
        [_pct setCenter:self.center];
        [self addSubview:_pct];
        
        [self startAnimating];
    }
    return self;
}

-(void)startAnimating
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.6;
    rotationAnimation.cumulative = true;
    rotationAnimation.repeatCount = MAXFLOAT;
    [_animation.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setProgress:(CGFloat)progress
{
    int num = floorf(progress*100);
    NSString *text = [NSString stringWithFormat:@"%d%%",num];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [_pct setText:text];
    if (num == 100) {
        self.hidden = true;
    }else{
        self.hidden = false;
    }
}



@end
