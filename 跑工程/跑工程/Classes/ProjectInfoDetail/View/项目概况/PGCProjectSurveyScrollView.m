//
//  PGCProjectSurveyScrollView.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectSurveyScrollView.h"
#import "PGCProjectDetailTagView.h"
#import "PGCProjectSurveySubview.h"
#import "PGCProjectInfo.h"
#import "PGCAlertView.h"
#import "PGCHintAlertView.h"
#import "PGCVIPServiceController.h"

@interface PGCProjectSurveyScrollView () <PGCAlertViewDelegate, PGCHintAlertViewDelegate>
{
    BOOL _isVIP;/** 判断是否是会员 */
}
@property (strong, nonatomic) PGCProjectSurveySubview *surveySubview;/** 项目概况 */
@property (strong, nonatomic) UILabel *introContentLabel;/** 项目简介 */
@property (strong, nonatomic) UILabel *materialLabel;/** 可能用到的材料 */

- (void)initUserInterface;/* 初始化用户界面 */

@end

@implementation PGCProjectSurveyScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}


#pragma mark - Init method

// 子控件布局
- (void)initUserInterface
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.showsVerticalScrollIndicator = false;
    [self.contentView addSubview:scrollView];
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    // 项目概况
    PGCProjectDetailTagView *surveyView = [[PGCProjectDetailTagView alloc] initWithTitle:@"项目概况"];
    [scrollView addSubview:surveyView];
    surveyView.sd_layout
    .topSpaceToView(scrollView, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    #pragma mark *** 项目概况子视图 ***
    PGCProjectSurveySubview *surveySubview = [[PGCProjectSurveySubview alloc] init];
    [scrollView addSubview:surveySubview];
    [surveySubview addBtnTarget:self action:@selector(respondsToCheckButton:)];
    self.surveySubview = surveySubview;
    surveySubview.sd_layout
    .topSpaceToView(surveyView, 10)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .autoHeightRatio(0);
    
    
    // 项目简介
    PGCProjectDetailTagView *introView = [[PGCProjectDetailTagView alloc] initWithTitle:@"项目简介"];
    [scrollView addSubview:introView];
    introView.sd_layout
    .topSpaceToView(surveySubview, 0)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    #pragma mark *** 项目简介内容 ***
    UILabel *introContentLabel = [[UILabel alloc] init];
    introContentLabel.textColor = PGCTextColor;
    introContentLabel.font = SetFont(14);
    introContentLabel.numberOfLines = 0;
    [scrollView addSubview:introContentLabel];
    self.introContentLabel = introContentLabel;
    introContentLabel.sd_layout
    .topSpaceToView(introView, 10)
    .leftSpaceToView(scrollView, 15)
    .rightSpaceToView(scrollView, 15)
    .autoHeightRatio(0);
    
    // 其他
    PGCProjectDetailTagView *otherView = [[PGCProjectDetailTagView alloc] initWithTitle:@"可能用到的设备，材料"];
    [scrollView addSubview:otherView];
    otherView.sd_layout
    .topSpaceToView(introContentLabel, 10)
    .leftSpaceToView(scrollView, 0)
    .rightSpaceToView(scrollView, 0)
    .heightIs(40);
    
    #pragma mark *** 可能用到的设置、材料视图 ***
    UILabel *materialLabel = [[UILabel alloc] init];
    materialLabel.textColor = PGCTextColor;
    materialLabel.font = SetFont(14);
    materialLabel.numberOfLines = 0;
    [scrollView addSubview:materialLabel];
    self.materialLabel = materialLabel;
    materialLabel.sd_layout
    .topSpaceToView(otherView, 10)
    .leftSpaceToView(scrollView, 15)
    .rightSpaceToView(scrollView, 15)
    .autoHeightRatio(0);
    
    [scrollView setupAutoContentSizeWithBottomView:materialLabel bottomMargin:20];
}


#pragma mark - Events

- (void)respondsToCheckButton:(UIButton *)sender
{
    PGCManager *manager = [PGCManager manager];
    [manager readTokenData];
    PGCUser *user = manager.token.user;
    if (!user) {
        [PGCProgressHUD showMessage:@"请先登录" toView:KeyWindow];
        return;
    }
    
    BOOL isRemind = [[PGCUserDefault valueForKey:@"isRemind"] boolValue];
    
    PGCAlertView *alert = nil;
    
    if (user.is_vip == 0) {
        
    } else {
        if (isRemind) {
            PGCVIPServiceController *vipVC = [[PGCVIPServiceController alloc] init];
            [[self getCurrentVC].navigationController pushViewController:vipVC animated:true];
        } else {
            alert = [[PGCAlertView alloc] initWithTitle:@"查看项目详情，需要您开通会员服务，如果您需要开通会员服务，请点击确定"];
        }
    }
    alert.delegate = self;
    [alert showAlertView];
}


#pragma mark - PGCAlertViewDelegate

- (void)alertView:(PGCAlertView *)alertView confirm:(UIButton *)confirm
{
    PGCVIPServiceController *vipVC = [[PGCVIPServiceController alloc] init];
    [[self getCurrentVC].navigationController pushViewController:vipVC animated:true];
}


- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        // UINavigationController *nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }    
    return result;
}



#pragma mark - Setter

- (void)setProject:(PGCProjectInfo *)project
{
    _project = project;
    if (!project) {
        return;
    }
    self.surveySubview.projectInfo = project;
    
    self.introContentLabel.text = project.desc;
    
    self.materialLabel.text = project.material;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    
    self.introContentLabel.attributedText = [[NSAttributedString alloc] initWithString:project.desc attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    self.introContentLabel.isAttributedContent = true;
    
    self.materialLabel.attributedText = [[NSAttributedString alloc] initWithString:project.material attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    self.materialLabel.isAttributedContent = true;
}


@end
