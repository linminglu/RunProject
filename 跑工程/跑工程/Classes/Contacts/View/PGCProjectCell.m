//
//  PGCProjectCell.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectCell.h"

@interface PGCProjectCell ()

@property (weak, nonatomic) IBOutlet UIView *contentLabel;

@end

@implementation PGCProjectCell

- (void)setContactRight:(PGCContact *)contactRight
{
    _contactRight = contactRight;
    if (!contactRight) {
        return;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
