//
//  PGCShareToFriendController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCShareToFriendController.h"

@interface PGCShareToFriendController ()

@property (copy, nonatomic) NSArray *shareBtnArray;/** 分享按钮名字数组 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCShareToFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"推荐APP";
    // 分享按钮图片数组
    _shareBtnArray = @[@"QQ好友", @"QQ空间", @"微信好友", @"朋友圈"];
    //创建四个分享按钮
    for (int i = 0; i < _shareBtnArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(30 + (i * (50 + (SCREEN_WIDTH - 260) / 3)) , SCREEN_HEIGHT - 80, 50, 70);
        button.tag = i;
        
//        if (SCREEN_WIDTH > 320.00) {// iPhone 6 & 6p 及以上的屏幕
//            button.frame = CGRectMake(30 + (i * (50 + (SCREEN_WIDTH - 260) / 3)) , SCREEN_HEIGHT - 80, 50, 80);
//        }
//        else {
//        }
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        [self creatBtnSubViewWithBtn:button index:i];
    }
}

#pragma mark - Private

/**
 创建btn的子控件
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
 */
- (void) shareBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0://QQ好友
        {
            
        }
            break;
        case 1://QQ空间
        {
            
        }
            break;
        case 2://微信好友
        {
            
        }
            break;
        case 3://朋友圈
        {
            
        }
            break;
        default:
            break;
    }
}

@end
