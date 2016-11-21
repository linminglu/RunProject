//
//  DemandDetailImagesCell.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "DemandDetailImagesCell.h"
#import "PGCBaseAPIManager.h"
#import "Images.h"
#import "PYPhotoBrowser.h"

@interface DemandDetailImagesCell ()

@property (strong, nonatomic) PYPhotosView *lineImagesView;/** 图片线性布局 */
@property (strong, nonatomic) NSMutableArray *thumbnailImageUrls;/** 图片链接(缩略图)数组 */
@property (strong, nonatomic) NSMutableArray *originalImageUrls;/** 图片(原图)链接数组 */
@end

@implementation DemandDetailImagesCell


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
    self.lineImagesView = [PYPhotosView photosView];
    self.lineImagesView.layoutType = PYPhotosViewLayoutTypeLine;
    [self.contentView addSubview:self.lineImagesView];
    self.lineImagesView.sd_layout
    .topSpaceToView(self.contentView, 8)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(70);
}


#pragma mark - Setter

- (void)setImageDatas:(NSArray<Images *> *)imageDatas
{
    _imageDatas = imageDatas;
    
    for (Images *image in imageDatas) {
        NSString *string = [image.image substringFromIndex:3];
        [self.thumbnailImageUrls addObject:[kBaseImageURL stringByAppendingString:string]];
        [self.originalImageUrls addObject:[kBaseImageURL stringByAppendingString:string]];
    }    
    self.lineImagesView.thumbnailUrls = self.thumbnailImageUrls;
    self.lineImagesView.originalUrls = self.originalImageUrls;
    
    [self setupAutoHeightWithBottomView:self.lineImagesView bottomMargin:8];
}


#pragma mark - Getter

- (NSMutableArray *)thumbnailImageUrls {
    if (!_thumbnailImageUrls) {
        _thumbnailImageUrls = [NSMutableArray array];
    }
    return _thumbnailImageUrls;
}

- (NSMutableArray *)originalImageUrls {
    if (!_originalImageUrls) {
        _originalImageUrls = [NSMutableArray array];
    }
    return _originalImageUrls;
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
