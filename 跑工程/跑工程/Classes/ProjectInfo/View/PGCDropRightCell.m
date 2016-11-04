//
//  PGCDropRightCell.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropRightCell.h"

@implementation PGCDropRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(240, 240, 240);
        
        [self createUI];
        [self setViewAutoLayout];
    }
    return self;
}


- (void)createUI {
    self.rightTitleLabel = [[UILabel alloc] init];
    self.rightTitleLabel.textColor = RGB(102, 102, 102);
    self.rightTitleLabel.font = SetFont(15);
    [self.contentView addSubview:self.rightTitleLabel];
    
    self.rightAccessoryView = [[UIImageView alloc] init];
    self.rightAccessoryView.image = [UIImage imageNamed:@"选中-对号"];
    self.rightAccessoryView.hidden = true;
    [self.contentView addSubview:self.rightAccessoryView];
}


- (void)setViewAutoLayout {
    CGSize size = [UIImage imageNamed:@"选中-对号"].size;
    
    self.rightAccessoryView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.rightTitleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.rightAccessoryView, 15)
    .autoHeightRatio(0);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.rightTitleLabel.textColor = PGCTintColor;
        self.rightAccessoryView.hidden = false;
    } else {
        self.rightTitleLabel.textColor = RGB(102, 102, 102);
        self.rightAccessoryView.hidden = true;
    }
}

@end
