//
//  DemandDetailFilesCell.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "DemandDetailFilesCell.h"
#import "Files.h"

@interface DemandDetailFilesCell ()

@property (strong, nonatomic) NSMutableArray<UIImageView *> *fileImageViews;


@end

@implementation DemandDetailFilesCell


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
    _fileImageViews = [NSMutableArray array];
    
    UIImageView *docImage = [[UIImageView alloc] init];
    docImage.image = [UIImage imageNamed:@"doc50"];
    [self.contentView addSubview:docImage];
    docImage.sd_layout
    .widthIs(50)
    .heightEqualToWidth()
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(self.contentView, 50);
    
    UIImageView *pdfImage = [[UIImageView alloc] init];
    pdfImage.image = [UIImage imageNamed:@"pdf50"];
    [self.contentView addSubview:pdfImage];
    pdfImage.sd_layout
    .widthIs(50)
    .heightEqualToWidth()
    .topSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 50);
    
    [_fileImageViews addObject:docImage];
    [_fileImageViews addObject:pdfImage];
}


#pragma mark - Setter

- (void)setFileDatas:(NSArray<Files *> *)fileDatas
{
    _fileDatas = fileDatas;
    
    [self setupAutoHeightWithBottomViewsArray:_fileImageViews bottomMargin:20];
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
