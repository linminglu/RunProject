//
//  PGCAboutUsViewController.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAboutUsViewController.h"

@interface PGCAboutUsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.title = @"关于我们";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.contentLabel.text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
}

@end
