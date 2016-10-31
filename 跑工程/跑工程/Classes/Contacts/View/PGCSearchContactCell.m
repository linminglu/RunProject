//
//  PGCSearchContactCell.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCSearchContactCell.h"
@interface PGCSearchContactCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation PGCSearchContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setNameStr:(NSString *)nameStr
{
    _nameStr = nameStr;
    self.nameLabel.text = nameStr;
}

@end
