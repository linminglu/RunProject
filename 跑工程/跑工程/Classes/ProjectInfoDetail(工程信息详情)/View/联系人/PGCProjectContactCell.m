//
//  PGCProjectContactCell.m
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCProjectContactCell.h"
#import "PGCProjectContact.h"

@interface PGCProjectContactCell ()
{
    UILabel *_contactLabel;     /** 联系人标签 */
    UILabel *_phoneLabel;       /** 电话标签 */
    UILabel *_telephoneLabel;   /** 座机标签 */
    UILabel *_companyLabel;     /** 单位标签 */
    UILabel *_addressLabel;     /** 地址标签 */
}

@property (strong, nonatomic) UIView *line;/** 分割线 */

@end

@implementation PGCProjectContactCell

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
    NSArray *titles = @[@"联系人：", @"手   机：", @"座   机：", @"单   位：", @"地   址："];
    NSMutableArray<UILabel *> *labels = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [self setLabelWithSuperView:self.contentView index:i title:titles[i]];
        [labels addObject:label];
    }
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
            {
                _contactLabel = [[UILabel alloc] init];
                _contactLabel.font = SetFont(13);
                _contactLabel.textColor = PGCTextColor;
                [self.contentView addSubview:_contactLabel];
                _contactLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self.contentView, 20)
                .heightRatioToView(obj, 1.0);
            }
                break;
            case 1:
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitleColor:PGCTintColor forState:UIControlStateNormal];
                [button setTitle:@"点击查看" forState:UIControlStateNormal];
                [button.titleLabel setFont:SetFont(11)];
                [button.layer setMasksToBounds:true];
                [button.layer setCornerRadius:10];
                [button.layer setBorderColor:PGCTintColor.CGColor];
                [button.layer setBorderWidth:1];
                [button addTarget:self action:@selector(respondsToCheckButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:button];
                button.sd_layout
                .centerYEqualToView(obj)
                .rightSpaceToView(self.contentView, 50)
                .heightIs(20)
                .widthIs(60);
                
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor lightGrayColor];
                [self.contentView addSubview:line];
                line.sd_layout
                .centerYEqualToView(obj)
                .rightSpaceToView(button, 10)
                .heightRatioToView(button, 0.8)
                .widthIs(1);
                
                _phoneLabel = [[UILabel alloc] init];
                _phoneLabel.font = SetFont(13);
                _phoneLabel.textColor = PGCTextColor;
                [self.contentView addSubview:_phoneLabel];
                _phoneLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(line, 10)
                .heightRatioToView(obj, 1.0);
            }
                break;
            case 2:
            {
                _telephoneLabel = [[UILabel alloc] init];
                _telephoneLabel.font = SetFont(13);
                _telephoneLabel.textColor = PGCTextColor;
                [self.contentView addSubview:_telephoneLabel];
                _telephoneLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self.contentView, 20)
                .heightRatioToView(obj, 1.0);
            }
                break;
            case 3:
            {
                _companyLabel = [[UILabel alloc] init];
                _companyLabel.font = SetFont(13);
                _companyLabel.textColor = PGCTextColor;
                [self.contentView addSubview:_companyLabel];
                _companyLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self.contentView, 20)
                .heightRatioToView(obj, 1.0);
            }
                break;
            default:
            {
                _addressLabel = [[UILabel alloc] init];
                _addressLabel.font = SetFont(13);
                _addressLabel.textColor = PGCTextColor;
                [self.contentView addSubview:_addressLabel];
                _addressLabel.sd_layout
                .centerYEqualToView(obj)
                .leftSpaceToView(obj, 10)
                .rightSpaceToView(self.contentView, 20)
                .heightRatioToView(obj, 1.0);
                _addressLabel.userInteractionEnabled = true;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAddressGesture:)];
                [_addressLabel addGestureRecognizer:tap];
            }
                break;
        }
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(230, 230, 240);
    [self.contentView addSubview:line];
    self.line = line;
    line.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(labels.lastObject, 0)
    .heightIs(1);
}


- (void)setProjectContact:(PGCProjectContact *)projectContact
{
    _projectContact = projectContact;
    if (!projectContact) {
        return;
    }
    _contactLabel.text = projectContact.name;
    _phoneLabel.text = projectContact.phone;
    _telephoneLabel.text = projectContact.telephone;
    _companyLabel.text = projectContact.company;
    _addressLabel.text = projectContact.address;

    [self setupAutoHeightWithBottomView:self.line bottomMargin:0];
}


- (UILabel *)setLabelWithSuperView:(UIView *)superView index:(NSInteger)index title:(NSString *)title
{
    CGSize size = [title sizeWithFont:SetFont(13) constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.font = SetFont(13);
    resultLabel.text = title;
    resultLabel.textColor = PGCTextColor;
    [superView addSubview:resultLabel];
    resultLabel.sd_layout
    .topSpaceToView(superView, index * 30)
    .leftSpaceToView(superView, 15)
    .heightIs(30)
    .widthIs(size.width);

    return resultLabel;
}


#pragma mark - Gesture

- (void)respondsToAddressGesture:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(projectContactCell:address:)]) {
        [self.delegate projectContactCell:self address:gesture];
    }
}


#pragma mark - Events

- (void)respondsToCheckButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(projectContactCell:phone:)]) {
        [self.delegate projectContactCell:self phone:sender];
    }
}


@end
