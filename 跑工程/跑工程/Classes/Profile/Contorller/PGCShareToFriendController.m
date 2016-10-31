//
//  PGCShareToFriendController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCShareToFriendController.h"

@interface PGCShareToFriendController ()

//分享按钮名字数组
@property (nonatomic,strong) NSArray *shareBtnArray;


//第一个文字视图X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fristLabViewX;
//二维码X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeImageX;
//第二个文字视图X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabViewX;
//二维码的H和W
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeW;

@end

@implementation PGCShareToFriendController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"推荐APP";
    [self.navigationController.navigationBar setHidden:NO];
//    设置文字视图的X和二维码的X
    self.fristLabViewX.constant = (SCREEN_WIDTH - 160) /2;
    self.codeImageX.constant = SCREEN_WIDTH /4 ;
    self.secondLabViewX.constant = (SCREEN_WIDTH - 160) /2;
    self.codeH.constant = SCREEN_WIDTH / 2;
    self.codeW.constant = SCREEN_WIDTH / 2;

//    分享按钮图片数组
    _shareBtnArray = @[@"QQ好友",@"QQ空间",@"微信好友",@"朋友圈"];
    
    [self creatShareBtn];
 
    
    
}
//创建分享按钮
- (void) creatShareBtn
{
//    6s,6p
    if (SCREEN_WIDTH > 320.00) {
        for (int i = 0; i < 4; i++) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30 +(i * (50 + (SCREEN_WIDTH - 260) / 3)) , SCREEN_HEIGHT * 0.8, 50, 70)];
            btn.tag = i;
            [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];

            [self creatBtnSubViewWithBtn:btn andIndex:i];
        }
    }
//    5s
    else
    {
        for (int i = 0; i < 4; i++) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30 +(i * (50 + (SCREEN_WIDTH - 260) / 3)) , 500, 50, 70)];
            [self.view addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            [self creatBtnSubViewWithBtn:btn andIndex:i];
        }
    }
}

//创建btn的子控件
- (void) creatBtnSubViewWithBtn:(UIButton *)btn andIndex:(int)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    [btn addSubview:imageView];
    imageView.image = [UIImage imageNamed:_shareBtnArray[index]];
    
    UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, 20)];
    [btn addSubview:btnLabel];
    btnLabel.text = [NSString stringWithFormat:@"%@",_shareBtnArray[index]];
    btnLabel.font = [UIFont systemFontOfSize:12];
    btnLabel.textColor = [UIColor grayColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    
}
//分享按钮点击事件
- (void) shareBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            NSLog(@"QQ好友");
            break;
        case 1:
            NSLog(@"QQ空间");
            break;
        case 2:
            NSLog(@"微信好友");
            break;
        case 3:
            NSLog(@"朋友圈");
            break;
            
        default:
            break;
    }
}

@end
