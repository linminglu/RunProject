//
//  PGCWebViewController.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCWebViewController.h"

@interface PGCWebViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PGCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详情";
    NSLog(@"%@", self.urlString);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.urlString] placeholderImage:[UIImage imageNamed:@"头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)closeBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

@end
