//
//  PGCCollectionViewCell.m
//  跑工程
//
//  Created by leco on 2016/10/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCCollectionViewCell.h"

@implementation PGCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
        [self setViewAutoLayout];
    }
    return self;
}

- (void)createUI {
    self.centerView = [[UIView alloc] init];
    self.centerView.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:self.centerView];
    
    self.collectionLabel = [[UILabel alloc] init];
    self.collectionLabel.textColor = RGB(102, 102, 102);
    self.collectionLabel.font = SetFont(14);
    [self.centerView addSubview:self.collectionLabel];
}

- (void)setViewAutoLayout {
    self.centerView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .bottomSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 10);
    
    self.collectionLabel.sd_layout
    .centerYEqualToView(self.centerView)
    .leftSpaceToView(self.centerView, 20)
    .rightSpaceToView(self.centerView, 20)
    .autoHeightRatio(0);
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.collectionLabel.textColor = PGCTintColor;
        
    } else {
        self.collectionLabel.textColor = RGB(102, 102, 102);
    }
}


@end
