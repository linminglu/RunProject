//
//  PGCProjectInfoCell.m
//  跑工程
//
//  Created by leco on 16/10/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectInfoCell.h"
#import "PGCProjectInfo.h"

@interface PGCProjectInfoCell ()

@property (nonatomic, strong) UILabel *nameLabel;/** 标题 */
@property (nonatomic, strong) UILabel *contentLabel;/** 内容 */
@property (nonatomic, strong) UILabel *categoryLabel;/** 项目类别 */
@property (nonatomic, strong) UILabel *stageLabel;/** 项目阶段 */
@property (nonatomic, strong) UILabel *areaLabel;/** 地区 */
@property (nonatomic, strong) UILabel *timeLabel;/** 时间 */
@property (strong, nonatomic) UIView *line;/** 底部分割线 */

@end

@implementation PGCProjectInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
        [self setupSubviewsAutoLayout];
    }
    return self;
}

- (void)createUI
{
    // 标题
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = RGB(76, 141, 174);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = RGB(102, 102, 102);
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 项目类别
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.font = [UIFont systemFontOfSize:12];
    categoryLabel.textColor = RGB(187, 187, 187);
    [self.contentView addSubview:categoryLabel];
    self.categoryLabel = categoryLabel;
    
    // 项目阶段
    UILabel *stageLabel = [[UILabel alloc] init];
    stageLabel.font = [UIFont systemFontOfSize:12];
    stageLabel.textColor = RGB(187, 187, 187);
    [self.contentView addSubview:stageLabel];
    self.stageLabel = stageLabel;
    
    // 地区
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.font = [UIFont systemFontOfSize:12];
    areaLabel.textColor = RGB(187, 187, 187);
    [self.contentView addSubview:areaLabel];
    self.areaLabel = areaLabel;
    
    // 时间标签
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = RGB(187, 187, 187);
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
}

#pragma mark - 在这里用三方自动布局进行约束

- (void)setupSubviewsAutoLayout
{
    // 标题
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    // 内容
    self.contentLabel.sd_layout
    .topSpaceToView(self.nameLabel, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    // 项目类别
    self.categoryLabel.sd_layout
    .topSpaceToView(self.contentLabel, 10)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(60)
    .heightIs(20);
    
    // 时间标签
    self.timeLabel.sd_layout
    .bottomEqualToView(self.categoryLabel)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(60)
    .heightIs(20);
    
    // 项目阶段
    self.stageLabel.sd_layout
    .centerYEqualToView(self.categoryLabel)
    .leftSpaceToView(self.categoryLabel, 0)
    .widthIs(60)
    .heightIs(20);
    
    // 地区
    self.areaLabel.sd_layout
    .centerYEqualToView(self.categoryLabel)
    .leftSpaceToView(self.stageLabel, 0)
    .rightSpaceToView(self.timeLabel, 20)
    .heightIs(20);
    
    // 底部分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = PGCBackColor;
    [self.contentView addSubview:line];
    self.line = line;
    line.sd_layout
    .topSpaceToView(self.categoryLabel, 10)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
}


- (void)setProject:(PGCProjectInfo *)project
{
    _project = project;
    
    self.nameLabel.text = project.name;
    self.contentLabel.text = project.desc;
    self.categoryLabel.text = project.type_name;
    self.stageLabel.text = project.progress_name;
    self.areaLabel.text = [project.province stringByAppendingString:project.city];
    NSString *start_time = [project.start_time substringToIndex:10];
    self.timeLabel.text = start_time;
    
    [self setupAutoHeightWithBottomView:self.line bottomMargin:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
