//
//  PGCShareToFriendController.m
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCShareToFriendController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface PGCShareToFriendController ()

@property (copy, nonatomic) NSArray *shareBtnArray;/** 分享按钮名字数组 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCShareToFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.title = @"推荐APP";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 分享按钮图片数组
    _shareBtnArray = @[@"QQ好友", @"QQ空间", @"微信好友", @"朋友圈"];
    //创建四个分享按钮
    for (int i = 0; i < _shareBtnArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(30 + (i * (50 + (SCREEN_WIDTH - 260) / 3)) , SCREEN_HEIGHT - 80, 50, 70);
        button.tag = i;
        
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
    __weak typeof(self) weakSelf = self;
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"120"]];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"工程宝在手，找信息不愁。"
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"工程宝"
                                       type:SSDKContentTypeAuto];
    switch (sender.tag) {
        case 0://QQ好友
        {
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        [weakSelf showAlert:@"分享成功" message:nil actionTitle:@"好的"];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        [weakSelf showAlert:@"分享失败" message:error.localizedDescription actionTitle:@"我知道了"];
                        break;
                    }
                    default:
                        break;
                }
            }];
        }
            break;
        case 1://QQ空间
        {
            [ShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        [weakSelf showAlert:@"分享成功" message:nil actionTitle:@"好的"];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        [weakSelf showAlert:@"分享失败" message:error.localizedDescription actionTitle:@"我知道了"];
                        break;
                    }
                    default:
                        break;
                }
            }];
        }
            break;
        case 2://微信好友
        {
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        [weakSelf showAlert:@"分享成功" message:nil actionTitle:@"好的"];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        [weakSelf showAlert:@"分享失败" message:error.localizedDescription actionTitle:@"我知道了"];
                        break;
                    }
                    default:
                        break;
                }
            }];
        }
            break;
        case 3://朋友圈
        {
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        [weakSelf showAlert:@"分享成功" message:nil actionTitle:@"好的"];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        [weakSelf showAlert:@"分享失败" message:error.localizedDescription actionTitle:@"我知道了"];
                        break;
                    }
                    default:
                        break;
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

@end
