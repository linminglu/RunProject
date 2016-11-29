//
//  PGCProjectCell.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectCell.h"
#import "PGCProject.h"

@interface PGCProjectCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation PGCProjectCell


#pragma mark - Setter

- (void)setProjectInfo:(PGCProject *)projectInfo
{
    _projectInfo = projectInfo;
    
    self.contentLabel.text = projectInfo.name;
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
