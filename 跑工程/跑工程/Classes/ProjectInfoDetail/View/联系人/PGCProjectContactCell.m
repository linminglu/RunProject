//
//  PGCProjectContactCell.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectContactCell.h"
#import "NSString+Size.h"

@interface PGCProjectContactCell ()

- (void)initUserInterface; /** 初始化用户界面 */

@end

@implementation PGCProjectContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *contents = @[@"***先生/女士", @"188********", @"023-********", @"重庆市******公司", @"重庆市江北区******"];
    NSArray *titles = @[@"联系人：", @"手   机：", @"传   真：", @"单   位：", @"地   址："];
    for (int i = 0; i < titles.count; i++) {
        [self setLabelWithSuperView:self.contentView index:i title:titles[i] content:contents[i]];
    }
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(230, 230, 250);
    [self.contentView addSubview:line];
    line.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .heightIs(1);
}

- (void)setLabelWithSuperView:(UIView *)superView
                        index:(NSInteger)index
                        title:(NSString *)title
                      content:(NSString *)content {
        
    CGSize sizeA = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    CGSize sizeB = [content sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UILabel *labelA = [[UILabel alloc] init];
    labelA.font = SetFont(13);
    labelA.text = title;
    labelA.textColor = PGCTextColor;
    [superView addSubview:labelA];
    labelA.sd_layout
    .topSpaceToView(superView, index * 34)
    .leftSpaceToView(superView, 15)
    .widthIs(sizeA.width)
    .heightIs(34);
    
    UILabel *labelB = [[UILabel alloc] init];
    labelB.textColor = PGCTextColor;
    labelB.text = content;
    labelB.font = SetFont(14);
    [superView addSubview:labelB];
    
    labelB.sd_layout
    .centerYEqualToView(labelA)
    .leftSpaceToView(labelA, 10)
    .heightRatioToView(labelA, 1)
    .widthIs(sizeB.width);
    
    if (index == 1) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [superView addSubview:line];
        line.sd_layout
        .centerYEqualToView(labelA)
        .leftSpaceToView(labelB, 20)
        .heightRatioToView(labelB, 0.5)
        .widthIs(1);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:PGCTintColor forState:UIControlStateNormal];
        [button setTitle:@"点击查看" forState:UIControlStateNormal];
        [button.titleLabel setFont:SetFont(11)];
        [button.layer setMasksToBounds:true];
        [button.layer setCornerRadius:8.0];
        [button.layer setBorderColor:PGCTintColor.CGColor];
        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(respondsToCheckButton:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        button.sd_layout
        .centerYEqualToView(labelA)
        .leftSpaceToView(line, 10)
        .heightRatioToView(line, 1)
        .widthIs(60);
    }
    if (index == 4) {
        labelB.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAddressGesture:)];
        [labelB addGestureRecognizer:tap];
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
//    
//    if ([touch.view isKindOfClass:[UIScrollView class]]) {
//        
//        return true;
//    }
//    return false;
//}

#pragma mark - Gesture

- (void)respondsToAddressGesture:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(projectContactCell:address:)]) {
        [self.delegate projectContactCell:self address:gesture];
    }
}


#pragma mark - Events

- (void)respondsToCheckButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(projectContactCell:phone:)]) {
        [self.delegate projectContactCell:self phone:sender];
    }
}


@end
