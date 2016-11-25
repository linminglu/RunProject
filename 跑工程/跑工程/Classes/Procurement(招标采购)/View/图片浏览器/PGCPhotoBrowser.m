//
//  PGCPhotoBrowser.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCPhotoBrowser.h"

static NSTimeInterval const duration = 0.4;

@interface PGCPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, PhotoBrowserCellDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIImageView *imageView;/** 缩放的图片视图 */
@property (weak, nonatomic) UILabel *descLabel;/** 说明标签 */
@property (weak, nonatomic) UICollectionView *collectionView;/** 集合视图 */
@property (weak, nonatomic) UIPageControl *pageCtl;/** 页面指示器 */
@property (weak, nonatomic) UIActivityIndicatorView *indicatorView;/** 活动指示器 */
@property (assign, nonatomic) NSUInteger currentSelectIndex;/** 当前页 */

@end

@implementation PGCPhotoBrowser

- (BOOL)prefersStatusBarHidden
{
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)show
{
    [KeyWindow endEditing:true];
    
    [KeyWindow.rootViewController addChildViewController:self];
    [KeyWindow.rootViewController.view addSubview:self.view];
    [self showFirstImageView];
}

- (void)showFirstImageView
{
    PGCPhoto *photo = [self.photos objectAtIndex:self.selectedIndex];
    // 加载图片介绍
    [self setupImageDesc:photo.desc];
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    BOOL existBigPic = false;
    self.imageView.image = [PGCPhoto existImageWithUrl:photo.url];
    if (self.imageView.image) { //查看大图是否存在
        existBigPic = true;
        
    } else {//查看小图是否存在
        self.imageView.image = [PGCPhoto existImageWithUrl:photo.thumbUrl];
        if (!self.imageView.image) { //大小图都不存在时
            self.imageView.image = [UIImage imageNamed:@"dialog_load"];
        }
    }
    
    // 渐变显示
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.imageView.frame = photo.scrRect;
    
    __weak __typeof(self) weakself = self;
    
    CGPoint screenCenter = self.view.window.center;
    
    [UIView animateWithDuration:duration animations:^{
        // 有大图直接显示大图，没有先显示小图
        if (existBigPic) {
            CGSize size = [PGCPhoto displaySize:self.imageView.image];
            weakself.imageView.frame = CGRectMake(0, 0, size.width, size.height);
            
            //长图处理
            if (size.height <= SCREEN_HEIGHT) {
                weakself.imageView.center = screenCenter;
            }
        } else {
            self.imageView.center = self.view.center;
        }
        weakself.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        
    } completion:^(BOOL finished) {
        
        [weakself.imageView removeFromSuperview];
        
        weakself.imageView = nil;
        weakself.collectionView.contentOffset = CGPointMake(self.selectedIndex * SCREEN_WIDTH, 0);
        weakself.pageCtl.numberOfPages = self.photos.count;
        weakself.pageCtl.currentPage = self.selectedIndex;
        weakself.currentSelectIndex = self.selectedIndex;
        [_collectionView setContentOffset:(CGPoint){weakself.currentSelectIndex * (self.view.bounds.size.width + 20),0} animated:false];
    }];
}

- (void)setupImageDesc:(NSString *)desc
{
    self.descLabel.text = desc;
    
    self.descLabel.sd_resetLayout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .bottomSpaceToView(self.pageCtl, 10)
    .autoHeightRatio(0);
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:8];
//    self.descLabel.attributedText = [[NSAttributedString alloc] initWithString:desc attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoBrowserCell forIndexPath:indexPath];
    
    PGCPhoto *photo = [self.photos objectAtIndex:indexPath.item];
    cell.photo = photo;
    cell.delegate = self;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewCell:cellForItemAtIndexPath:)]) {
        [self.delegate collectionViewCell:cell cellForItemAtIndexPath:indexPath];
    }
    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentSelectIndex = round(scrollView.contentOffset.x / (SCREEN_WIDTH + 20));
    
    self.pageCtl.currentPage = self.currentSelectIndex;
}


#pragma mark - PhotoBrowserCellDelegate

- (void)didSelectedPhotoBrowserCell:(PhotoBrowserCell *)cell
{
    if (cell.imageView.frame.size.height > SCREEN_HEIGHT || cell.imageView.frame.size.width > SCREEN_WIDTH) {
        self.imageView = [[UIImageView alloc] init];
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(SCREEN_SIZE, true, 0.0);
        
        // 将下载完的image对象绘制到图形上下文
        CGFloat width = cell.imageView.frame.size.width;
        CGFloat height = width *  cell.imageView.image.size.height /  cell.imageView.image.size.width;
        [cell.imageView.image drawInRect:CGRectMake(0, 0,  cell.imageView.image.size.width, height)];
        
        // 获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        CGRect frame = cell.imageView.frame;
        frame.size.height = SCREEN_HEIGHT;
        self.imageView.frame = frame;
        
        // 结束图形上下文
        UIGraphicsEndImageContext();
        [self.view addSubview:self.imageView];
        [self.collectionView removeFromSuperview];
        
        [self hide:self.imageView with:cell.photo];
        
    } else {
        [self hide:cell.imageView with:cell.photo];
    }
}

- (void)hide:(UIImageView *)imageView with:(PGCPhoto *)photo
{
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [imageView setFrame:photo.scrRect];
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)longPressPhotoBrowserCell:(PhotoBrowserCell *)cell
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf saveImage];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)saveImage
{
    PGCPhoto *photo = self.photos[self.currentSelectIndex];
    // 保存到本地相册
    UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    // 初始化活动指示器
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = true;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @">_< 保存失败";
    }   else {
        label.text = @"^_^ 保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}


#pragma mark - Getter

- (UILabel *)descLabel {
    if (!_descLabel) {
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.font = [UIFont systemFontOfSize:15];
        descLabel.textColor = [UIColor whiteColor];
        descLabel.numberOfLines = 0;
        descLabel.clipsToBounds = true;
        [self.view addSubview:descLabel];
        _descLabel = descLabel;
    }
    return _descLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        bounds.size.width += 10;
        
        // 1.create layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = true;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[PhotoBrowserCell class] forCellWithReuseIdentifier:kPhotoBrowserCell];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pageCtl {
    if (!_pageCtl) {
        UIPageControl *pageCtl = [[UIPageControl alloc] init];
        pageCtl.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        pageCtl.userInteractionEnabled = false;
        [self.view addSubview:pageCtl];
        
        _pageCtl = pageCtl;
    }
    return _pageCtl;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
