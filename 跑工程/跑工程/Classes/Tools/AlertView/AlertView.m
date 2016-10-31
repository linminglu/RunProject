//
//  AlertView.m
//  GraduationProject
//
//  Created by Chrissy on 16/3/30.
//  Copyright © 2016年 Liushengtao. All rights reserved.
//

#import "AlertView.h"

// 按钮颜色
#define OKBUTTON_BGCOLOR [UIColor colorWithRed:158/255.0 green:214/255.0 blue:243/255.0 alpha:1]

#define CANCELBUTTON_BGCOLOR [UIColor colorWithRed:255/255.0 green:20/255.0 blue:20/255.0 alpha:1]

// 按钮起始tag
#define TAG 100

NSUInteger const Button_Size_Width = 80;
NSUInteger const Button_Size_Height = 30;

NSInteger const Title_Font = 18;
NSInteger const Detial_Font = 16;

//Logo半径（画布）
NSInteger const Logo_Size = 40;

NSInteger const Button_Font = 16;

@interface AlertView ()
{
    UIView *_logoView;//画布
    UILabel * _titleLabel;//标题
    UILabel * _detailLabel;//详情
    
    UIButton * _OkButton;//确定按钮
    UIButton * _canleButton;//取消按钮
    
    CAShapeLayer * _pathLayer;//尝试保护内存
}

@end

@implementation AlertView

+ (instancetype)showAlertViewWithStyle:(AlertViewStyle)style title:(NSString *)title detail:(NSString *)detail cancelButtonTitle:(NSString *)cancel okButtonTitle:(NSString *)ok callBlock:(CallBack)callBack {
    switch (style) {
        case AlertViewStyleDefalut:
            [[self shared] drawRight];
            break;
        case AlertViewStyleSuccess:
            [[self shared] drawRight];
            
            break;
        case AlertViewStyleFail:
            [[self shared] drawWrong];
            
            break;
        case AlertViewStyleWaring:
            [[self shared] drawWaring];
            
            break;
        default:
            break;
    }
    [[self shared] addButtonTitleWithCancel:cancel OK:ok];
    [[self shared] addTitle:title detail:detail];
    [[self shared] setClickBlock:nil];  //释放掉之前的Block
    [[self shared] setClickBlock:callBack];
    [[self shared] setHidden:false];   //设置为不隐藏
    
    return  [self shared];
}

+ (instancetype)showAlertViewWithTitle:(NSString *)title detail:(NSString *)detail cancelButtonTitle:(NSString *)cancel okButtonTitle:(NSString *)ok callBlock:(CallBack)callBack {
    return [self showAlertViewWithStyle:AlertViewStyleSuccess title:title detail:detail cancelButtonTitle:cancel okButtonTitle:ok callBlock:callBack];
}

#pragma mark - 单例
//单例
+ (instancetype)shared {
    static dispatch_once_t once = 0;
    static AlertView *alert = nil;
    dispatch_once(&once, ^{
        alert = [[AlertView alloc] init];
    });
    return alert;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        self.alpha = 1;
        [self setBackgroundColor:[UIColor clearColor]];
        self.hidden = false;//不隐藏
        self.windowLevel = 100;
        
        [self setInterFace];
    }
    return self;
}
/**
 *  界面初始化
 */
- (void)setInterFace {
    [self logoInit];
    [self controlsInit];
}

/**
 *  初始化控件
 */
- (void)controlsInit {
    
    CGFloat x = _logoView.frame.origin.x;
    CGFloat y = _logoView.frame.origin.y;
    CGFloat height = _logoView.frame.size.height;
    CGFloat width = _logoView.frame.size.width;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x ,y + height / 2, width, Title_Font + 5)];
    [_titleLabel setFont:[UIFont systemFontOfSize:Title_Font]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    _detailLabel  = [[UILabel alloc] initWithFrame:CGRectMake(x ,y + height / 2 + (Title_Font + 10), width, Detial_Font + 5)];
    _detailLabel.textColor = [UIColor grayColor];
    [_detailLabel setFont:[UIFont systemFontOfSize:Detial_Font]];
    [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat centerY = _detailLabel.center.y + 40;
    
    _OkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _OkButton.layer.cornerRadius = 5;
    _OkButton.titleLabel.font = [UIFont systemFontOfSize:Button_Font];
    _OkButton.center = CGPointMake(_detailLabel.center.x + 50, centerY);
    _OkButton.bounds = CGRectMake(0, 0, Button_Size_Width, Button_Size_Height);
    _OkButton.backgroundColor = OKBUTTON_BGCOLOR;
    
    
    _canleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _canleButton.center = CGPointMake(_detailLabel.center.x - 50, centerY);
    _canleButton.bounds = CGRectMake(0, 0, Button_Size_Width, Button_Size_Height);
    _canleButton.backgroundColor = CANCELBUTTON_BGCOLOR;
    _canleButton.layer.cornerRadius = 5;
    _canleButton.titleLabel.font = [UIFont systemFontOfSize:Button_Font];
    
    
    [self addSubview:_titleLabel];
    [self addSubview:_detailLabel];
    [self addSubview:_OkButton];
    [self addSubview:_canleButton];
    
    _canleButton.hidden = true;
    _OkButton.hidden = true;
    
    _OkButton.tag = TAG;
    _canleButton.tag = TAG + 1;
    
    [_OkButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_canleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
- (void)buttonClick:(UIButton *)sender {
    self.clickBlock(sender.tag - TAG);
}

/**
 *  添加标题信息和详细信息
 *
 *  @param title  标题内容
 *  @param detail 详细内容
 */
- (void)addTitle:(NSString *)title detail:(NSString *)detail {
    _titleLabel.text  = title;
    _detailLabel.text = detail;
}

/**
 *  @author by wangkun, 15-03-11 17:03:53
 *
 *  添加按钮
 *
 *  @param cancle 按钮标题
 *  @param ok     按钮标题
 */
- (void) addButtonTitleWithCancel:(NSString *)cancel OK:(NSString *)ok {
    BOOL flag = false;
    if (cancel == nil && ok != nil ) {
        flag = true;
    }
    
    CGFloat centerY = _detailLabel.center.y + 40;
    
    if (flag) {
        _OkButton.center = CGPointMake(_detailLabel.center.x, centerY);
        _OkButton.bounds = CGRectMake(0, 0, Button_Size_Width, Button_Size_Height);
        _canleButton.hidden = true;
    } else {
        _canleButton.hidden = false;
        [_canleButton setTitle:cancel forState:UIControlStateNormal];
        _OkButton.center = CGPointMake(_detailLabel.center.x + 50, centerY);
        _OkButton.bounds = CGRectMake(0, 0, Button_Size_Width, Button_Size_Height);
    }
    _OkButton.hidden = false;
    [_OkButton setTitle:ok forState:UIControlStateNormal];
}

#pragma mark - Private
/**

 *  画圆和勾
 */
- (void)drawRight {
    
    [self logoInit];
    //自绘制图标中心点
    CGPoint pathCenter = CGPointMake(_logoView.frame.size.width/2, _logoView.frame.size.height/2 - 50);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:pathCenter radius:Logo_Size startAngle:0 endAngle:M_PI*2 clockwise:true];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    
    CGFloat x = _logoView.frame.size.width/2.5 + 5;
    CGFloat y = _logoView.frame.size.height/2 - 45;
    //勾的起点
    [path moveToPoint:CGPointMake(x, y)];
    //勾的最底端
    CGPoint p1 = CGPointMake(x+10, y+ 10);
    [path addLineToPoint:p1];
    //勾的最上端
    CGPoint p2 = CGPointMake(x+35,y-20);
    [path addLineToPoint:p2];
    //新建图层——绘制上面的圆圈和勾
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [_logoView.layer addSublayer:layer];
}

/**
 *  画圆角矩形和叉
 */
- (void)drawWrong {
    
    [self logoInit];
    
    CGFloat x = _logoView.frame.size.width / 2 - Logo_Size;
    CGFloat y = 15;
    
    //圆角矩形
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, Logo_Size * 2, Logo_Size * 2) cornerRadius:5];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    CGFloat space = 20;
    //斜线1
    [path moveToPoint:CGPointMake(x + space, y + space)];
    CGPoint p1 = CGPointMake(x + Logo_Size * 2 - space, y + Logo_Size * 2 - space);
    [path addLineToPoint:p1];
    //斜线2
    [path moveToPoint:CGPointMake(x + Logo_Size * 2 - space , y + space)];
    CGPoint p2 = CGPointMake(x + space, y + Logo_Size * 2 - space);
    [path addLineToPoint:p2];
    
    //新建图层——绘制上述路径
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.lineWidth = 5;
    layer.path = path.CGPath;

    // 使用NSStringFromSelector(@selector(strokeEnd))作为KeyPath的作用，绘制动画每一次Show均重复运行
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5;
    // 和上对应
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [_logoView.layer addSublayer:layer];
}

/**
 *  画三角形以及感叹号
 */
-(void) drawWaring {
//    [_logoView removeFromSuperview];
    [self logoInit];
    //自绘制图标中心店
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    //绘制三角形
    CGFloat x = _logoView.frame.size.width/2;
    CGFloat y = 15;
    //三角形起点（上方）
    [path moveToPoint:CGPointMake(x, y)];
    //左边
    CGPoint p1 = CGPointMake(x - 45, y + 80);
    [path addLineToPoint:p1];
    //右边
    CGPoint p2 = CGPointMake(x + 45,y + 80);
    [path addLineToPoint:p2];
    //关闭路径
    [path closePath];
    
    //绘制感叹号
    //绘制直线
    [path moveToPoint:CGPointMake(x, y + 20)];
    CGPoint p4 = CGPointMake(x, y + 60);
    [path addLineToPoint:p4];
    //绘制实心圆
    [path moveToPoint:CGPointMake(x, y + 70)];
    [path addArcWithCenter:CGPointMake(x, y + 70) radius:2 startAngle:0 endAngle:M_PI*2 clockwise:true];
    
    //新建图层——绘制上述路径
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor orangeColor].CGColor;
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [_logoView.layer addSublayer:layer];
}

/**
 *  初始化logo视图——画布
 */
// 需完善画布的清除，不适用移除，新建的办法
- (void)logoInit {
    //移除画布
    [_logoView removeFromSuperview];
    _logoView = nil;
    //新建画布
    _logoView                     = [UIView new];
    _logoView.center              = CGPointMake(self.center.x, self.center.y - 40);
    _logoView.bounds              = CGRectMake(0, 0, 320 / 1.5, 320 / 1.5);
    _logoView.backgroundColor     = [UIColor whiteColor];
    _logoView.layer.cornerRadius  = 10;
    _logoView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _logoView.layer.shadowOffset  = CGSizeMake(0, 5);
    _logoView.layer.shadowOpacity = 0.3f;
    _logoView.layer.shadowRadius  = 10.0f;
    
    //保证画布位于所有视图层级的最下方
    if (_titleLabel != nil) {
        [self insertSubview:_logoView belowSubview:_titleLabel];
    } else {
        [self addSubview:_logoView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
