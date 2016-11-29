//
//  IntroduceDemandTopCell.m
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "IntroduceDemandTopCell.h"
#import "PGCIntroducePublicView.h"
#import "PGCIntroduceSelectView.h"
#import "PGCDemand.h"

@interface IntroduceDemandTopCell () <UITextFieldDelegate>

@property (strong, nonatomic) PGCIntroducePublicView *title;/** 标题 */
@property (strong, nonatomic) PGCIntroducePublicView *startTime;/** 开始时间 */
@property (strong, nonatomic) PGCIntroducePublicView *endTime;/** 结束时间  */
@property (strong, nonatomic) PGCIntroducePublicView *unit;/** 采购单位 */
@property (strong, nonatomic) PGCIntroducePublicView *address;/** 地址 */
@property (strong, nonatomic) PGCIntroduceSelectView *area;/** 地区 */
@property (strong, nonatomic) PGCIntroduceSelectView *demand;/** 需求 */
@property (strong, nonatomic) UIView *timeAccessoryView;/** 时间选择器的inputAccessoryView */
@property (strong, nonatomic) UIDatePicker *datePicker;/** 时间选择器 */

@end

@implementation IntroduceDemandTopCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.title = [[PGCIntroducePublicView alloc] initWithTitle:@"标题：" placeholder:@"请输入标题"];
    self.title.contentTF.delegate = self;
    self.title.contentTF.tag = DemandTitleTF;
    [self.contentView addSubview:self.title];
    self.title.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 灰色分割视图
    UIView *grayView_1 = [[UIView alloc] init];
    grayView_1.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:grayView_1];
    grayView_1.sd_layout
    .topSpaceToView(self.title, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(8);
    
    // 开始时间
    self.startTime = [[PGCIntroducePublicView alloc] initWithTitle:@"时间：" placeholder:@"请选择时间"];
    self.startTime.contentTF.delegate = self;
    self.startTime.contentTF.tag = DemandStartTimeTF;
    [self.contentView addSubview:self.startTime];
    self.startTime.contentTF.inputView = self.timeAccessoryView;
    self.startTime.sd_layout
    .topSpaceToView(grayView_1, 0)
    .leftSpaceToView(self.contentView, 0)
    .widthRatioToView(self.contentView, 0.5)
    .heightIs(44);
    
    // 结束时间
    self.endTime = [[PGCIntroducePublicView alloc] initWithTitle:@"至" placeholder:@"请选择时间"];
    self.endTime.contentTF.delegate = self;
    self.endTime.contentTF.tag = DemandEndTimeTF;
    [self.contentView addSubview:self.endTime];
    self.endTime.contentTF.inputView = self.timeAccessoryView;
    self.endTime.sd_layout
    .centerYEqualToView(self.startTime)
    .leftSpaceToView(self.startTime, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 时间下面的分割线
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line_1];
    line_1.sd_layout
    .topSpaceToView(self.startTime, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    
    self.unit = [[PGCIntroducePublicView alloc] initWithTitle:@"采购单位（个人）：" placeholder:@"请输入采购单位"];
    self.unit.contentTF.delegate = self;
    self.unit.contentTF.tag = DemandUnitTF;
    [self.contentView addSubview:self.unit];
    self.unit.sd_layout
    .topSpaceToView(line_1, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 采购单位下面的分割线
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line_2];
    line_2.sd_layout
    .topSpaceToView(self.unit, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    
    self.address = [[PGCIntroducePublicView alloc] initWithTitle:@"地址：" placeholder:@"请输入地址"];
    self.address.contentTF.delegate = self;
    self.address.contentTF.tag = DemandAddressTF;
    [self.contentView addSubview:self.address];
    self.address.sd_layout
    .topSpaceToView(line_2, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 灰色分割视图
    UIView *grayView_2 = [[UIView alloc] init];
    grayView_2.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:grayView_2];
    grayView_2.sd_layout
    .topSpaceToView(self.address, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(8);
    
    
    self.area = [[PGCIntroduceSelectView alloc] initWithTitle:@"地区：" content:@"点击选择"];
    [self.area addTarget:self action:@selector(selectArea:)];
    [self.contentView addSubview:self.area];
    self.area.sd_layout
    .topSpaceToView(grayView_2, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    // 地区下面的分割线
    UIView *line_3 = [[UIView alloc] init];
    line_3.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:line_3];
    line_3.sd_layout
    .topSpaceToView(self.area, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    
    self.demand = [[PGCIntroduceSelectView alloc] initWithTitle:@"需求：" content:@"点击选择"];
    [self.demand addTarget:self action:@selector(selectDemand:)];
    [self.contentView addSubview:self.demand];
    self.demand.sd_layout
    .topSpaceToView(line_3, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(44);
    
    [self setupAutoHeightWithBottomView:self.demand bottomMargin:0];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = textField.text.length > 0 ? textField.text : @"";
    
    switch (textField.tag) {
        case DemandTitleTF: self.topDemand.title = text;
            break;
        case DemandStartTimeTF:
        {
            [self timeWithBlock:^(NSString *timeStr) {
                textField.text = [timeStr substringToIndex:10];
                
                self.topDemand.start_time = timeStr;
            }];
        }
            break;
        case DemandEndTimeTF:
        {
            [self timeWithBlock:^(NSString *timeStr) {
                textField.text = [timeStr substringToIndex:10];
                
                self.topDemand.end_time = timeStr;
            }];
        }
            break;
        case DemandUnitTF: self.topDemand.company = text;
            break;
        case DemandAddressTF: self.topDemand.address = text;
            break;
        default:
            break;
    }
}

- (void)timeWithBlock:(void(^)(NSString *timeStr))timeBlock
{
    timeBlock([self stringFromDate:self.datePicker.date]);
}

#pragma mark - Event

- (void)selectArea:(UIButton *)sender
{
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDemandTopCell:selectArea:)]) {
        [self.delegate introduceDemandTopCell:self selectArea:sender];
    }
}

- (void)selectDemand:(UIButton *)sender
{
    if (self.delegate || [self.delegate respondsToSelector:@selector(introduceDemandTopCell:selectDemand:)]) {
        [self.delegate introduceDemandTopCell:self selectDemand:sender];
    }
}


- (void)btnClickedEvent:(UIButton *)sender
{
    [self endEditing:true];
}


- (void)surebtnClickedEvent:(UIButton *)sender
{
    [self endEditing:true];
    
    [self timeWithBlock:^(NSString *timeStr) {
        
    }];
}


#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    return [formatter stringFromDate:date];
}


#pragma mark - Setter

- (void)setTopDemand:(PGCDemand *)topDemand
{
    _topDemand = topDemand;
    
    self.title.contentTF.text = topDemand.title ? topDemand.title : @"";
    self.startTime.contentTF.text = topDemand.start_time ? [topDemand.start_time substringToIndex:10] : @"";
    self.endTime.contentTF.text = topDemand.end_time ? [topDemand.end_time substringToIndex:10] : @"";
    self.unit.contentTF.text = topDemand.company ? topDemand.company : @"";
    self.address.contentTF.text = topDemand.address ? topDemand.address : @"";
    NSString *areaStr = @"点击选择";
    if (topDemand.city) {
        areaStr = topDemand.province ? [topDemand.province stringByAppendingString:topDemand.city] : @"点击选择";
    } else {
        areaStr = topDemand.province ? topDemand.province : @"点击选择";
    }
    [self.area.selectBtn setTitle:areaStr forState:UIControlStateNormal];
    [self.demand.selectBtn setTitle:topDemand.type_name ? topDemand.type_name : @"点击选择" forState:UIControlStateNormal];
}


#pragma mark - Getter

- (UIView *)timeAccessoryView {
    if (!_timeAccessoryView) {
        _timeAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
        _timeAccessoryView.backgroundColor = [UIColor whiteColor];
        
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        accessoryView.backgroundColor = PGCTintColor;
        [_timeAccessoryView addSubview:accessoryView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, 100, 40);
        [cancelBtn addTarget:self action:@selector(btnClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
        [accessoryView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 100, 40);
        [sureBtn addTarget:self action:@selector(surebtnClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [accessoryView addSubview:sureBtn];
        
        [_timeAccessoryView addSubview:self.datePicker];
    }
    return _timeAccessoryView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 156)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
    }
    return _datePicker;
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
