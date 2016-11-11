//
//  PGCShareToFriendController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCShareToFriendController.h"

@interface PGCShareToFriendController ()
//二维码的H和W
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeW;


@property (copy, nonatomic) NSArray *shareBtnArray;/** 分享按钮名字数组 */

- (void)initializeDataSource; /** 初始化数据源 */
- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCShareToFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
}

- (void)initializeUserInterface {
    self.navigationItem.title = @"推荐APP";
    
    // 设置文字视图的X和二维码的X
    self.codeH.constant = SCREEN_WIDTH / 2;
    self.codeW.constant = SCREEN_WIDTH / 2;
    
    // 分享按钮图片数组
    _shareBtnArray = @[@"QQ好友", @"QQ空间", @"微信好友", @"朋友圈"];
    //创建四个分享按钮
    for (int i = 0; i < _shareBtnArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        if (SCREEN_WIDTH > 320.00) {// iPhone 6 & 6p 及以上的屏幕
            button.frame = CGRectMake(30 + (i * (50 + (SCREEN_WIDTH - 260) / 3)) , SCREEN_HEIGHT * 0.8, 50, 70);
        }
        else {
            button.frame = CGRectMake(30 + (i * (50 + (SCREEN_WIDTH - 260) / 3)) , 500, 50, 70);
        }
        button.tag = i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self creatBtnSubViewWithBtn:button index:i];
    }
}

#pragma mark - Private

/**
 创建btn的子控件

 @param btn
 @param index
 */
- (void)creatBtnSubViewWithBtn:(UIButton *)btn index:(int)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    [btn addSubview:imageView];
    imageView.image = [UIImage imageNamed:_shareBtnArray[index]];
    
    UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, 20)];
    [btn addSubview:btnLabel];
    btnLabel.text = [NSString stringWithFormat:@"%@", _shareBtnArray[index]];
    btnLabel.font = [UIFont systemFontOfSize:12];
    btnLabel.textColor = [UIColor grayColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
}


#pragma mark - Event
/**
 分享按钮点击事件

 @param sender
 */
- (void) shareBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [PGCProgressHUD showMessage:@"QQ好友" inView:self.view];
            break;
        case 1:
            [PGCProgressHUD showMessage:@"QQ空间" inView:self.view];
            break;
        case 2:
            [PGCProgressHUD showMessage:@"微信好友" inView:self.view];
            break;
        case 3:
            [PGCProgressHUD showMessage:@"朋友圈" inView:self.view];
            break;
        default:
            break;
    }
}

@end
