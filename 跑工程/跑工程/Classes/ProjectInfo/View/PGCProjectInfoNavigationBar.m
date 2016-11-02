//
//  PGCProjectInfoNavigationBar.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoNavigationBar.h"

#define ITEM_WIDTH 50
#define PADDING 5

@implementation PGCProjectInfoBarItem

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        
        [self setupSubviewsWithImage:image text:title];
    }
    return self;
}

- (void)setupSubviewsWithImage:(UIImage *)image text:(NSString *)text {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
    CGSize imageSize = image.size;
    imageView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 6)
    .widthIs(imageSize.width)
    .heightIs(imageSize.height);
    
    self.barItemImage = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [self addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SetFont(11);
    label.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(imageView, 5)
    .autoHeightRatio(0);
    
    self.barItemLabel = label;
}

@end


@interface PGCProjectInfoNavigationBar ()
/**
 地图模式
 */
@property (strong, nonatomic) UIView *mapModeView;


- (void)initUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectInfoNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = PGCThemeColor;
    
    PGCProjectInfoBarItem *mapBarItem = [[PGCProjectInfoBarItem alloc] initWithImage:[UIImage imageNamed:@"地图"] title:@"地图模式"];
    [self addSubview:mapBarItem];
    mapBarItem.tag = mapItemTag;
    [mapBarItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    mapBarItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .leftSpaceToView(self, 15)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
    
    PGCProjectInfoBarItem *searchItem = [[PGCProjectInfoBarItem alloc] initWithImage:[UIImage imageNamed:@"项目搜索"] title:@"搜索"];
    [self addSubview:searchItem];
    searchItem.tag = searchItemTag;
    [searchItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    searchItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .rightSpaceToView(self, PADDING)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
    
    PGCProjectInfoBarItem *collectItem = [[PGCProjectInfoBarItem alloc] initWithImage:[UIImage imageNamed:@"我的收藏"] title:@"我的收藏"];
    [self addSubview:collectItem];
    collectItem.tag = collectItemTag;
    [collectItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    collectItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .rightSpaceToView(searchItem, PADDING)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
    
    PGCProjectInfoBarItem *checkRecordItem = [[PGCProjectInfoBarItem alloc] initWithImage:[UIImage imageNamed:@"查看记录"] title:@"查看记录"];
    [self addSubview:checkRecordItem];
    checkRecordItem.tag = recordItemTag;
    [checkRecordItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    checkRecordItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .rightSpaceToView(collectItem, PADDING)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
}

- (void)respondsToNavigationItemEvent:(PGCProjectInfoBarItem *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(projectInfoNavigationBar:tapItem:)]) {
        [self.delegate projectInfoNavigationBar:self tapItem:sender.tag];
    }
}

@end
