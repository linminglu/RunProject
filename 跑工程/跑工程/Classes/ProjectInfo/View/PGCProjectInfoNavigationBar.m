//
//  PGCProjectInfoNavigationBar.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoNavigationBar.h"
#import "PGCNavigationItem.h"

#define ITEM_WIDTH 50
#define PADDING 5

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

- (void)initUserInterface
{
    PGCNavigationItem *mapBarItem = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"地图"] title:@"地图模式"];
    [self addSubview:mapBarItem];
    mapBarItem.tag = mapItemTag;
    [mapBarItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    mapBarItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .leftSpaceToView(self, 15)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
    
    PGCNavigationItem *searchItem = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"项目搜索"] title:@"搜索"];
    [self addSubview:searchItem];
    searchItem.tag = searchItemTag;
    [searchItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    searchItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .rightSpaceToView(self, PADDING)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
    
    PGCNavigationItem *collectItem = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"我的收藏"] title:@"我的收藏"];
    [self addSubview:collectItem];
    collectItem.tag = collectItemTag;
    [collectItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    collectItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .rightSpaceToView(searchItem, PADDING)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
    
    PGCNavigationItem *checkRecordItem = [[PGCNavigationItem alloc] initWithImage:[UIImage imageNamed:@"查看记录"] title:@"查看记录"];
    [self addSubview:checkRecordItem];
    checkRecordItem.tag = recordItemTag;
    [checkRecordItem addTarget:self action:@selector(respondsToNavigationItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    checkRecordItem.sd_layout
    .topSpaceToView(self, STATUS_BAR_HEIGHT)
    .rightSpaceToView(collectItem, PADDING)
    .bottomSpaceToView(self, 0)
    .widthIs(ITEM_WIDTH);
}

- (void)respondsToNavigationItemEvent:(PGCNavigationItem *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(projectInfoNavigationBar:tapItem:)]) {
        [self.delegate projectInfoNavigationBar:self tapItem:sender.tag];
    }
}

@end
