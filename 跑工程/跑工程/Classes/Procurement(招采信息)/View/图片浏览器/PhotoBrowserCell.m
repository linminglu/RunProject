
//  PhotoBrowserCell.m
//  跑工程
//
//  Created by leco on 2016/11/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhotoBrowserCell.h"
#import "PhotoProgressView.h"

@interface PhotoBrowserCell() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollview;
@property (nonatomic, weak) PhotoProgressView *progressView;

@end


@implementation PhotoBrowserCell

#pragma mark - 监听处理

- (void)prepareForReuse
{
    [_photo removeObserver:self forKeyPath:@"downLoad"];
}

- (void)dealloc
{
    [_photo removeObserver:self forKeyPath:@"downLoad"];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.imageView.image = self.photo.image;
    [UIView animateWithDuration:0.4 animations:^{
        self.imageView.bounds = self.photo.imageViewBounds;
    }];
}


#pragma mark - Gesture

- (void)scrollViewDidTap
{
    if ([self.delegate respondsToSelector:@selector(didSelectedPhotoBrowserCell:)]) {
        [self.delegate didSelectedPhotoBrowserCell:self];
    }
}

// 长按保存手势
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressPhotoBrowserCell:)]) {
            [self.delegate longPressPhotoBrowserCell:self];
        }
    }
}

- (void)scrollViewDidDoubleTap:(UITapGestureRecognizer *)doubleTap
{
    // 这里先判断图片是否下载好,, 如果没下载好, 直接return
    if(!_imageView.image) return;
    
    if(_scrollview.zoomScale <= 1){
        // 1.获取到 手势 在 自身上的 位置
        // 2.scrollView的偏移量 x(为负) + 手势的 x 需要放大的图片的X点
        CGFloat x = [doubleTap locationInView:self].x + _scrollview.contentOffset.x;
        
        // 3.scrollView的偏移量 y(为负) + 手势的 y 需要放大的图片的Y点
        CGFloat y = [doubleTap locationInView:self].y + _scrollview.contentOffset.y;
        [_scrollview zoomToRect:(CGRect){{x,y}, CGSizeZero} animated:true];
        
    } else {
        // 设置 缩放的大小  还原
        [_scrollview setZoomScale:1.0f animated:true];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//控制缩放是在中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
}



#pragma mark - Setter

- (void)setPhoto:(PGCPhoto *)photo
{
    _photo = photo;
    [self reset];
    
    [photo addObserver:self forKeyPath:@"downLoad" options:NSKeyValueObservingOptionNew context:nil];
    
    __weak __typeof(self)weakself = self;
    [photo setProgressBlock:^(CGFloat progress) {
        weakself.progressView.progress = progress;
    }];
    self.imageView.image = photo.image;
    self.imageLabel.text = photo.desc;
    self.imageLabel.sd_layout
    .leftSpaceToView(self.scrollview, 20)
    .rightSpaceToView(self.scrollview, 20)
    .bottomSpaceToView(self.scrollview, 50)
    .autoHeightRatio(0);
    if (photo.imageViewBounds.size.height <= SCREEN_HEIGHT) {
        self.imageView.bounds = photo.imageViewBounds;
        self.imageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        
    } else {
        self.scrollview.contentSize = photo.imageViewBounds.size;
        self.imageView.frame = CGRectMake(0, 0, photo.imageViewBounds.size.width, photo.imageViewBounds.size.height);
    }
}

- (void)reset
{
    self.scrollview.contentInset = UIEdgeInsetsZero;
    self.scrollview.contentSize = CGSizeZero;
    self.imageView.transform = CGAffineTransformIdentity;
}



#pragma mark - Getter

- (UIScrollView *)scrollview {
    if (!_scrollview) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS];
        scrollView.maximumZoomScale = 2.25;
        scrollView.minimumZoomScale = 0.75;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        
        [self.contentView addSubview:scrollView];
        _scrollview = scrollView;
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _scrollview;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.userInteractionEnabled = true;
        
        // 1.生产 两种 手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidTap)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidDoubleTap:)];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        
        // 2.设置 手势的要求
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [doubleTap setNumberOfTapsRequired:2];
        [doubleTap setNumberOfTouchesRequired:1];
        
        // 3.避免两种手势冲突
        [tap requireGestureRecognizerToFail:doubleTap];
        
        // 4.添加 手势
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:doubleTap];
        [self addGestureRecognizer:longPress];
        
        [self.scrollview addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)imageLabel {
    if (!_imageLabel) {
        UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        imageLabel.font = [UIFont systemFontOfSize:16];
        imageLabel.textColor = [UIColor whiteColor];
        imageLabel.numberOfLines = 0;
        imageLabel.clipsToBounds = true;
        
        [self.scrollview addSubview:imageLabel];
        _imageLabel = imageLabel;
    }
    return _imageLabel;
}

- (PhotoProgressView *)progressView {
    if (!_progressView) {
        PhotoProgressView *progressView = [[PhotoProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        progressView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        progressView.progress = 0;
        [self.contentView addSubview:progressView];
        _progressView = progressView;
    }
    return _progressView;
}



@end
