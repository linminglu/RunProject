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

static NSString * const kFilesCollectionCell = @"FilesCollectionCell";

#pragma mark -
#pragma mark - FilesCollectionCell

@interface FilesCollectionCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;/** 图片视图 */
@end

@implementation FilesCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = RGB(244, 244, 244);
    [self.contentView addSubview:self.imageView];
    self.imageView.sd_layout
    .topSpaceToView(self.contentView, 5)
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .bottomSpaceToView(self.contentView, 5);
}
@end


#pragma mark -
#pragma mark - DemandDetailImagesCell

@interface DemandDetailImagesCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *imageCollection;/** 图像集合视图 */
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.contentView.width_sd / 4, self.contentView.width_sd / 4);
    self.imageCollection = [[UICollectionView alloc] initWithFrame:self.contentView.frame collectionViewLayout:flowLayout];
    self.imageCollection.backgroundColor = [UIColor whiteColor];
    self.imageCollection.dataSource = self;
    self.imageCollection.delegate = self;
    [self.contentView addSubview:self.imageCollection];
    [self.imageCollection registerClass:[FilesCollectionCell class] forCellWithReuseIdentifier:kFilesCollectionCell];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFilesCollectionCell forIndexPath:indexPath];
    NSString *imageUrl = [kBaseURL stringByAppendingString:self.imageDatas[indexPath.item].image];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


#pragma mark - Setter

- (void)setImageDatas:(NSArray<Images *> *)imageDatas
{
    _imageDatas = imageDatas;
    CGFloat collectionViewHeight = ((imageDatas.count % 4) > 0) ? (imageDatas.count / 4 + 1) * (SCREEN_WIDTH / 4) : (imageDatas.count / 4) * (SCREEN_WIDTH / 4);
    self.imageCollection.sd_resetNewLayout
    .topSpaceToView(self.contentView ,0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(collectionViewHeight);
    [self setupAutoHeightWithBottomView:self.imageCollection bottomMargin:0];
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
