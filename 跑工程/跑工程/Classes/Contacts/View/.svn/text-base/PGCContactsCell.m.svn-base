//
//  PGCContactsCell.m
//  跑工程
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactsCell.h"

@implementation PGCContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setContactsArray:(NSArray *)contactsArray
{
    _contactsArray = contactsArray;
//    创建联系人组名
    UILabel *sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    sectionNameLabel.font = [UIFont systemFontOfSize:15];
    sectionNameLabel.textColor = [UIColor orangeColor];
    sectionNameLabel.text = @"A";
    [self.contentView addSubview:sectionNameLabel];
//    分界线
    UIView *SeparatorView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sectionNameLabel.frame ) + 10, SCREEN_WIDTH - 20, 1)];
    SeparatorView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:SeparatorView];
    
//    创建联系人
    for (int i = 0; i < contactsArray.count; i++) {
//        联系人姓名
        UILabel *contactsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40 + 10 + i *70, 120, 20)];
        contactsNameLabel.font = [UIFont systemFontOfSize:15];
        contactsNameLabel.text = contactsArray[i];
        [self.contentView addSubview:contactsNameLabel];
//        项目名
        UILabel *projectsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(contactsNameLabel.frame) + 10, 120, 20)];
        projectsNameLabel.font = [UIFont systemFontOfSize:12];
        projectsNameLabel.textColor = [UIColor grayColor];
        projectsNameLabel.text = @"中铁八局";
        [self.contentView addSubview:projectsNameLabel];
//        右边的箭头
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, CGRectGetMaxY(contactsNameLabel.frame) - 5, 10, 20)];
        rightImageView.image = [UIImage imageNamed:@"right"];
        [self.contentView addSubview:rightImageView];
        
        //    分界线
        UIView *SeparatorView1 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(projectsNameLabel.frame ) + 10, SCREEN_WIDTH - 20, 1)];
        SeparatorView1.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:SeparatorView1];
        
    }
}

@end
