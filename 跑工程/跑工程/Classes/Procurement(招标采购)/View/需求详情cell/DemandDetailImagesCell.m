//
//  DemandDetailImagesCell.m
//  跑工程
//
//  Created by leco on 2016/11/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "DemandDetailImagesCell.h"
#import "PGCBaseAPIManager.h"
#import "PGCPhotoBrowser.h"
#import "Images.h"

@interface ImageGroup : UIView <BrowerCellDelegate>
@property (copy, nonatomic) NSArray<Images *> *imageItemArray;
@end

@implementation ImageGroup
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)setImageItemArray:(NSArray *)imageItemArray
{
    _imageItemArray = imageItemArray;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger perRowImageCount = (imageItemArray.count > 4) ? 1 : 0;
    
    CGFloat width = (SCREEN_WIDTH - 60) / 4;
    CGFloat height = width;
    
    [imageItemArray enumerateObjectsUsingBlock:^(Images *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = (idx % 4) * (width + 10);
        CGFloat y = perRowImageCount * (height + 10);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        imageView.backgroundColor = PGCBackColor;
        imageView.tag = idx;
        imageView.userInteractionEnabled = true;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
        [self addSubview:imageView];
        
        NSString *string = [kBaseImageURL stringByAppendingString:obj.image];
        [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
    }];
}
- (void)imageTap:(UITapGestureRecognizer *)gestrue
{
    NSMutableArray *photos = [NSMutableArray array];
    int i = 0;
    for (UIImageView *imageView in self.subviews) {
        Images *image = self.imageItemArray[i];
        PGCPhoto *photo = [[PGCPhoto alloc] init];
        NSString *string = [kBaseImageURL stringByAppendingString:image.image];
        photo.url = string;
        photo.thumbUrl = string;
        photo.desc = image.imageDec;
        photo.scrRect = [imageView convertRect:imageView.bounds toView:nil];
        [photos addObject:photo];
        i++;
    }
    PGCPhotoBrowser *brower = [[PGCPhotoBrowser alloc] init];
    brower.photos = photos;
    brower.selectedIndex = gestrue.view.tag;
    brower.delegate = self;
    [brower show];
}
@end


@interface DemandDetailImagesCell ()

@property (weak, nonatomic) ImageGroup *imageGroup;/** 图片组 */

@end

@implementation DemandDetailImagesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    ImageGroup *imageGroup = [[ImageGroup alloc] init];
    [self.contentView addSubview:imageGroup];
    self.imageGroup = imageGroup;
}


#pragma mark - Setter

- (void)setImageDatas:(NSArray<Images *> *)imageDatas
{
    _imageDatas = imageDatas;

    CGFloat height = (SCREEN_WIDTH - 60) / 4 + 10;
    if (imageDatas.count > 4) {
        height = height * 2;
    }
    self.imageGroup.sd_resetLayout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(height);
    
    self.imageGroup.imageItemArray = imageDatas;
    
    [self setupAutoHeightWithBottomView:self.imageGroup bottomMargin:0];
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
