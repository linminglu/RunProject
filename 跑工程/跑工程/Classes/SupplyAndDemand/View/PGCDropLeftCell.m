//
//  PGCDropLeftCell.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropLeftCell.h"


@implementation PGCDropLeftCell

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
    self.leftTitleLabel = [[UILabel alloc] init];
    self.leftTitleLabel.textColor = RGB(102, 102, 102);
    self.leftTitleLabel.font = SetFont(14);
    [self.contentView addSubview:self.leftTitleLabel];
    
    self.leftAccessoryView = [[UIImageView alloc] init];
    self.leftAccessoryView.image = [UIImage imageNamed:@"方向-right"];
    self.leftAccessoryView.hidden = true;
    [self.contentView addSubview:self.leftAccessoryView];
}


- (void)setViewAutoLayout {
    CGSize size = [UIImage imageNamed:@"方向-right"].size;
    
    self.leftAccessoryView.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 10)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.leftTitleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.leftAccessoryView, 10)
    .autoHeightRatio(0);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.leftTitleLabel.textColor = PGCTintColor;
        self.leftAccessoryView.hidden = false;

    } else {
        self.leftTitleLabel.textColor = RGB(102, 102, 102);
        self.leftAccessoryView.hidden = true;

    }
}

@end
