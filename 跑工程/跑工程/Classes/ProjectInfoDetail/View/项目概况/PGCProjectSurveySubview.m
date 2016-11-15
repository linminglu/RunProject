//
//  PGCProjectSurveySubview.m
//  跑工程
//
//  Created by leco on 2016/11/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectSurveySubview.h"
#import "PGCProjectInfo.h"

@interface PGCProjectSurveySubview ()
{
    UILabel *_areaLabel;/** 工程地区标签 */
    UILabel *_typeLabel;/** 项目类别标签 */
    UILabel *_stageLabel;/** 项目阶段标签 */
    UILabel *_timeLabel;/** 建筑周期标签 */
    UILabel *_addressLabel;/** 项目地址标签 */
    UIButton *_checkBtn;/** 点击查看按钮 */
}

@end

@implementation PGCProjectSurveySubview

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    NSArray *titles = @[@"工程地区：", @"项目类别：", @"项目阶段：", @"建筑周期：", @"项目地址："];
    NSMutableArray<UILabel *> *labels = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [self setLabelWithSuperView:self index:i title:titles[i]];
        [labels addObject:label];
    }
    
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
            {
                _areaLabel = [[UILabel alloc] init];
                _areaLabel.font = SetFont(14);
                _areaLabel.textColor = PGCTextColor;
                [self addSubview:_areaLabel];
                _areaLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self, 10)
                .heightRatioToView(obj, 1.0);
            }
                break;
            case 1:
            {
                _typeLabel = [[UILabel alloc] init];
                _typeLabel.font = SetFont(14);
                _typeLabel.textColor = PGCTextColor;
                [self addSubview:_typeLabel];
                _typeLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self, 10)
                .heightRatioToView(obj, 1.0);
            }
                break;
            case 2:
            {
                _stageLabel = [[UILabel alloc] init];
                _stageLabel.font = SetFont(14);
                _stageLabel.textColor = PGCTextColor;
                [self addSubview:_stageLabel];
                _stageLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self, 10)
                .heightRatioToView(obj, 1.0);
            }
                break;
            case 3:
            {
                _timeLabel = [[UILabel alloc] init];
                _timeLabel.font = SetFont(14);
                _timeLabel.textColor = PGCTextColor;
                [self addSubview:_timeLabel];
                _timeLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self, 10)
                .heightRatioToView(obj, 1.0);
            }
                break;
            case 4:
            {
                _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_checkBtn setTitleColor:PGCTintColor forState:UIControlStateNormal];
                [_checkBtn setTitle:@"点击查看" forState:UIControlStateNormal];
                [_checkBtn.titleLabel setFont:SetFont(10)];
                [_checkBtn.layer setMasksToBounds:true];
                [_checkBtn.layer setCornerRadius:10];
                [_checkBtn.layer setBorderColor:PGCTintColor.CGColor];
                [_checkBtn.layer setBorderWidth:1];
                [self addSubview:_checkBtn];
                _checkBtn.sd_layout
                .centerYEqualToView(obj)
                .rightSpaceToView(self, 30)
                .heightIs(20)
                .widthIs(60);
                
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:line];
                line.sd_layout
                .centerYEqualToView(obj)
                .rightSpaceToView(_checkBtn, 15)
                .heightRatioToView(_checkBtn, 0.8)
                .widthIs(1);
                
                _addressLabel = [[UILabel alloc] init];
                _addressLabel.font = SetFont(14);
                _addressLabel.textColor = PGCTextColor;
                [self addSubview:_addressLabel];
                _addressLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(line, 10)
                .heightRatioToView(obj, 1.0);
            }
                break;
            default:
                break;
        }
    }];
    [self setupAutoHeightWithBottomView:_addressLabel bottomMargin:10];
}


#pragma mark - Public
/* 点击查看按钮的事件 */
- (void)addBtnTarget:(id)target action:(SEL)action
{
    [_checkBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)loadDataWithModel:(id)model
{
    PGCProjectInfo *project = model;
    _areaLabel.text = [project.province stringByAppendingString:project.city];
    _typeLabel.text = project.type_name;
    _stageLabel.text = project.progress_name;
    NSString *startStr = [self stringFromOldStr:project.start_time];
    NSString *endStr = [self stringFromOldStr:project.end_time];
    _timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@", startStr, endStr];
    _addressLabel.text = project.address;
}


#pragma mark - Private

/* 自定义创建标签方法 */
- (UILabel *)setLabelWithSuperView:(UIView *)superView index:(NSInteger)index title:(NSString *)title {
    
    CGSize sizeA = [title sizeWithFont:SetFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.font = SetFont(14);
    resultLabel.text = title;
    resultLabel.textColor = PGCTextColor;
    [superView addSubview:resultLabel];
    resultLabel.sd_layout
    .topSpaceToView(superView, index * (LabelHeight + 5))
    .leftSpaceToView(superView, 15)
    .widthIs(sizeA.width)
    .heightIs(LabelHeight);

    return resultLabel;
}

/* 时间字符串格式转换 */
- (NSString *)stringFromOldStr:(NSString *)oldStr
{
    NSDateFormatter *formatter_1 = [[NSDateFormatter alloc] init];
    [formatter_1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter_1 dateFromString:oldStr];
    
    NSDateFormatter *formatter_2 = [[NSDateFormatter alloc] init];
    [formatter_2 setDateFormat:@"yyyy年MM月"];
    
    return [formatter_2 stringFromDate:date];
}


@end
