//
//  PGCDetailSubview2.m
//  跑工程
//
//  Created by leco on 2016/11/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDetailSubviewBottom.h"
#import "PGCProjectDetailTagView.h"

@interface PGCDetailSubviewBottom ()

@property (strong, nonatomic) UIButton *checkMoreContactBtn;

@end

@implementation PGCDetailSubviewBottom

- (instancetype)initWithModel:(id)model;
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubviewsWithModel:model];
    }
    return self;
}

- (void)setupSubviewsWithModel:(id)model
{
    UIImage *image = [UIImage imageNamed:@"加号"];
    NSString *title = @"查看更多联系人";
    CGSize titleSize = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UIButton *checkMoreContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkMoreContactBtn setImage:image forState:UIControlStateNormal];
    [checkMoreContactBtn.titleLabel setFont:SetFont(14)];
    [checkMoreContactBtn setTitle:title forState:UIControlStateNormal];
    [checkMoreContactBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
    self.checkMoreContactBtn = checkMoreContactBtn;
    [self addSubview:checkMoreContactBtn];
    checkMoreContactBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 0)
    .heightIs(40)
    .widthIs(image.size.width + titleSize.width + 30);
    
    checkMoreContactBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    checkMoreContactBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    
    PGCProjectDetailTagView *introduce = [[PGCProjectDetailTagView alloc] initWithTitle:@"详细介绍"];
    [self addSubview:introduce];
    introduce.sd_layout
    .topSpaceToView(checkMoreContactBtn, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    // 详细介绍的内容
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.text = @"我们公司主要经营的是什么什么样的业务和服务，有需要的请联系我们";
    introduceLabel.textColor = RGB(102, 102, 102);
    introduceLabel.font = SetFont(15);
    introduceLabel.numberOfLines = 0;
    [self addSubview:introduceLabel];
    introduceLabel.sd_layout
    .topSpaceToView(introduce, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
    
    PGCProjectDetailTagView *imageIntroduce = [[PGCProjectDetailTagView alloc] initWithTitle:@"图片介绍"];
    [self addSubview:imageIntroduce];
    imageIntroduce.sd_layout
    .topSpaceToView(introduceLabel, 15)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(40);
    
    NSMutableArray<UIImageView *> *imageArray = [NSMutableArray array];
    
    CGFloat imageWidth = (SCREEN_WIDTH - 15 * 2 - 5 * 3) / 4;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = RGB(240, 240, 240);
        [self addSubview:imageView];
        [imageArray addObject:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(self, 15 + i * (imageWidth + 5))
        .topSpaceToView(imageIntroduce, 15)
        .widthIs(imageWidth)
        .heightEqualToWidth();
    }
    [self setupAutoHeightWithBottomViewsArray:imageArray bottomMargin:15];
}


- (void)addDetailTarget:(id)target action:(SEL)action {
    [self.checkMoreContactBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
