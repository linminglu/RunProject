//
//  PGCProjectInfoCell.m
//  跑工程
//
//  Created by leco on 16/10/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoCell.h"

@interface PGCProjectInfoCell ()

// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 内容
@property (nonatomic, strong) UILabel *contentLabel;
// 项目类别
@property (nonatomic, strong) UILabel *categoryLabel;
// 项目阶段
@property (nonatomic, strong) UILabel *stageLabel;
// 地区
@property (nonatomic, strong) UILabel *areaLabel;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation PGCProjectInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = RGB(76, 141, 174);
        _titleLabel.text = @"需求和供应信息的标题";
        [self.contentView addSubview:_titleLabel];
        
        // 内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH - 20, 60)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = RGB(102, 102, 102);
        _contentLabel.text = @"需求和供应信息的标题需求和供应信息的标题需求和供应信息的标题需求和供应信息的标题";
        [self.contentView addSubview:_contentLabel];
        
        // 项目类别
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_contentLabel.frame), 80, 20)];
        _categoryLabel.font = [UIFont systemFontOfSize:12];
        _categoryLabel.textColor = RGB(187, 187, 187);
        _categoryLabel.text = @"机电设备";
        [self.contentView addSubview:_categoryLabel];
        
        // 项目阶段
        _stageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_categoryLabel.frame) , CGRectGetMaxY(_contentLabel.frame), 80, 20)];
        _stageLabel.font = [UIFont systemFontOfSize:12];
        _stageLabel.textColor = RGB(187, 187, 187);
        _stageLabel.text = @"机电设备";
        [self.contentView addSubview:_stageLabel];
        
        // 地区
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_stageLabel.frame), CGRectGetMaxY(_contentLabel.frame), 80, 20)];
        _areaLabel.font = [UIFont systemFontOfSize:12];
        _areaLabel.textColor = RGB(187, 187, 187);
        _areaLabel.text = @"重庆市江北区";
        [self.contentView addSubview:_areaLabel];
        
        // 时间标签
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, CGRectGetMaxY(_contentLabel.frame), 80, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = RGB(187, 187, 187);
        _timeLabel.text = @"2016.9.14";
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
