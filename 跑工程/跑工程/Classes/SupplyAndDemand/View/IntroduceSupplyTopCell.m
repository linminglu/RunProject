//
//  IntroduceSupplyTopCell.m
//  跑工程
//
//  Created by leco on 2016/11/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "IntroduceSupplyTopCell.h"
#import "PGCIntroducePublicView.h"
#import "PGCIntroduceSelectView.h"

@interface IntroduceSupplyTopCell ()

@property (strong, nonatomic) PGCIntroducePublicView *title;/** 标题 */
@property (strong, nonatomic) PGCIntroducePublicView *company;/** 供应商 */
@property (strong, nonatomic) PGCIntroducePublicView *address;/** 地址 */
@property (strong, nonatomic) PGCIntroduceSelectView *area;/** 地区 */
@property (strong, nonatomic) PGCIntroduceSelectView *type;/** 类别 */

@end

@implementation IntroduceSupplyTopCell


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
