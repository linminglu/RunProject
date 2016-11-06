//
//  PGCDropCenterCell.m
//  跑工程
//
//  Created by leco on 2016/11/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropCenterCell.h"

@implementation PGCDropCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
        [self setViewAutoLayout];
    }
    return self;
}


- (void)createUI {
    self.centerTitleLabel = [[UILabel alloc] init];
    self.centerTitleLabel.textColor = RGB(102, 102, 102);
    self.centerTitleLabel.font = SetFont(15);
    self.centerTitleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.centerTitleLabel];
}


- (void)setViewAutoLayout {
    self.centerTitleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 30)
    .autoHeightRatio(0);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.centerTitleLabel.textColor = PGCTintColor;
    } else {
        self.centerTitleLabel.textColor = RGB(102, 102, 102);
    }
}

@end
