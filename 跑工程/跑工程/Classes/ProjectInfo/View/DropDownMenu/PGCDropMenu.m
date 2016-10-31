//
//  PGCDropMenu.m
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropMenu.h"
#import "PGCTableViewCell.h"

#define BackColor [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0]
// 选中颜色加深
#define SelectColor [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0]

@interface PGCDropMenu () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
/**
 判断是否显示下拉列表
 */
@property (nonatomic, assign, getter=isShow) BOOL show;
/**
 当前选中菜单的下标
 */
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
/**
 菜单按钮个数
 */
@property (nonatomic, assign) NSInteger numOfMenu;
/**
 主视图的坐标
 */
@property (nonatomic, assign) CGPoint origin;
/**
 背景视图
 */
@property (nonatomic, strong) UIView *backGroundView;
/**
 底部横线视图
 */
@property (nonatomic, strong) UIView *bottomLine;
/**
 下拉菜单左边表格视图
 */
@property (nonatomic, strong) UITableView *leftTableView;
/**
 下拉菜单右边表格视图
 */
@property (nonatomic, strong) UITableView *rightTableView;
/**
 下拉菜单集合视图
 */
@property (nonatomic, strong) UICollectionView *collectionView;

#pragma mark - Layers
/**
 按钮标题数组
 */
@property (nonatomic, copy) NSArray *titles;
/**
 指示器数组
 */
@property (nonatomic, copy) NSArray *indicators;
/**
 背景图层数组
 */
@property (nonatomic, copy) NSArray<CALayer *> *bgLayers;
/**
 选择左边的行标
 */
@property (nonatomic, assign) NSInteger leftSelectedRow;
/**
 是否选择
 */
@property (nonatomic, assign) BOOL hadSelected;

@end

@implementation PGCDropMenu

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = false;
        _hadSelected = false;
        
        [self setupTableView:origin];
        [self setupCollectView:origin];
        
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        [self setupBackgroundView:origin];
    }
    return self;
}

- (void)setupBackgroundView:(CGPoint)origin {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
    _backGroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _backGroundView.opaque = false;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [_backGroundView addGestureRecognizer:gesture];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, screenSize.width, 0.5)];
    _bottomLine.backgroundColor = RGB(102, 102, 102);
    [self addSubview:_bottomLine];
}

- (void)setupTableView:(CGPoint)origin {
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.height, 0, 0) style:UITableViewStylePlain];
    _leftTableView.backgroundColor = [UIColor whiteColor];
    _leftTableView.rowHeight = 45;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.width, self.frame.origin.y + self.height, 0, 0) style:UITableViewStylePlain];
    _rightTableView.backgroundColor = PGCBackColor;
    _rightTableView.rowHeight = 45;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
}

- (void)setupCollectView:(CGPoint)origin {
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    flowLayout.itemSize = CGSizeMake((self.width - 10 * 4) / 3, 40);
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.height, self.width, 0) collectionViewLayout:flowLayout];
//    _collectionView.backgroundColor = [UIColor whiteColor];
//    [_collectionView registerClass:[PGCCollectionViewCell class] forCellWithReuseIdentifier:kPGCCollectionViewCell];
//    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
//    
//    self.autoresizesSubviews = NO;
//    _leftTableView.autoresizesSubviews = NO;
//    _rightTableView.autoresizesSubviews = NO;
//    _collectionView.autoresizesSubviews = NO;
}


#pragma mark - Public

- (NSString *)titleForRowAtIndexPath:(PGCIndexPath *)indexPath {
    
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}


#pragma mark - Gesture
/**
 点击菜单栏的事件

 @param paramSender
 */
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    CGPoint touchPoint = [paramSender locationInView:self];
    
    NSInteger tapIndex = touchPoint.x / (self.width / _numOfMenu);
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] forward:false complete:^{
                [self animateTitle:_titles[i] show:false complete:^{
                    
                }];
            }];
            [self.bgLayers[i] setBackgroundColor:[UIColor whiteColor].CGColor];
        }
    }
    BOOL displayByCollectionView = false;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:tapIndex];
    }
    
    if (displayByCollectionView) {
        [self displayCollectionView:tapIndex];
    } else {
        [self displayTableView:tapIndex];
    }
}

/**
 displayTableView
 
 @param tapIndex
 */
- (void)displayTableView:(NSInteger)tapIndex {
    BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:tapIndex];
    
    UITableView *rightTableView = nil;
    
    if (haveRightTableView) {
        rightTableView = _rightTableView;
        // 修改左右tableview显示比例
        
    }
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:false complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = false;
        }];
        
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    } else {
        
        _hadSelected = false;
        
        _currentSelectedMenudIndex = tapIndex;
        
        if ([_dataSource respondsToSelector:@selector(currentLeftSelectedRow:)]) {
            
            _leftSelectedRow = [_dataSource currentLeftSelectedRow:_currentSelectedMenudIndex];
        }
        
        if (rightTableView) {
            [rightTableView reloadData];
        }
        [_leftTableView reloadData];
        
        CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
        if (_leftTableView) {
            
            _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
        }
        
        if (_rightTableView) {
            
            _rightTableView.frame = CGRectMake(_origin.x+_leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
        }
        
        if (_currentSelectedMenudIndex!=-1) {
            // 需要隐藏collectionview
            //                [self animateCollectionView:_collectionView show:NO complete:^{
            //
            //                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
            //                        _show = YES;
            //                    }];
            //                }];
            
        } else{
            [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
                _show = YES;
            }];
        }
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
    }
}

/**
 displayCollectionView

 @param tapIndex
 */
- (void)displayCollectionView:(NSInteger)tapIndex {
    UICollectionView *collectionView = nil;
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
        }];
        
        [self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    } else {
        
        _currentSelectedMenudIndex = tapIndex;
        
//        [_collectionView reloadData];
        
        if (_currentSelectedMenudIndex != -1) {
            // 需要隐藏tableview
            [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:false complete:^{
                
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:true complecte:^{
                    _show = true;
                }];
            }];
        } else{
            [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:true complecte:^{
                _show = true;
            }];
        }
        [self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    }
}

/**
 点击Background的事件

 @param paramSender
 */
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender {
    BOOL displayByCollectionView = false;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex];
    }
//    if (displayByCollectionView) {
//        
//        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
//            _show = NO;
//        }];
//        
//    } else{
//        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
//            _show = NO;
//        }];
//    }
    
    [self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
}


#pragma mark - Animation
/**
 动画显示表格视图下拉菜单

 @param leftTableView
 @param rightTableView
 @param show
 @param complete
 */
- (void)animateLeftTableView:(UITableView *)leftTableView
              rightTableView:(UITableView *)rightTableView
                        show:(BOOL)show
                    complete:(void(^)())complete {
    
    CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
    
    if (show) {
        
        CGFloat leftTableViewHeight = 0;
        
        CGFloat rightTableViewHeight = 0;
        
        if (leftTableView) {
            
            leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width * ratio, 0);
            [self.superview addSubview:leftTableView];
            
            leftTableViewHeight = self.superview.height * 0.6;
            
            //            leftTableViewHeight = ([leftTableView numberOfRowsInSection:0] > 8) ? (8 * leftTableView.rowHeight) : ([leftTableView numberOfRowsInSection:0] * leftTableView.rowHeight);
            
        }
        
        if (rightTableView) {
            
            rightTableView.frame = CGRectMake(_origin.x + leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            
            [self.superview addSubview:rightTableView];
            
            rightTableViewHeight = self.superview.height * 0.6;
            
            //            rightTableViewHeight = ([rightTableView numberOfRowsInSection:0] > 8) ? (8 * rightTableView.rowHeight) : ([rightTableView numberOfRowsInSection:0] * rightTableView.rowHeight);
            
        }
        
        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width * ratio, tableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x + leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width * (1 - ratio), tableViewHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            }
            
        } completion:^(BOOL finished) {
            
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
    }
    complete();
}

/**
 动画显示集合视图下拉菜单

 @param collectionView
 @param show
 @param complete
 */
- (void)animateCollectionView:(UICollectionView *)collectionView
                         show:(BOOL)show
                     complete:(void(^)())complete {
    
    if (show) {
        
        CGFloat collectionViewHeight = 0;
        
        if (collectionView) {
            
            collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            [self.superview addSubview:collectionView];
            
            collectionViewHeight = 40 * 3 + 10 * 4;
            
            //            collectionViewHeight = ([collectionView numberOfItemsInSection:0] > 10) ? (5 * 40) : (ceil([collectionView numberOfItemsInSection:0]/2) * 40);
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, collectionViewHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            }
        } completion:^(BOOL finished) {
            
            if (collectionView) {
                [collectionView removeFromSuperview];
            }
        }];
    }
    complete();
}

- (void)animateIndicator:(CAShapeLayer *)indicator
                 forward:(BOOL)forward
                complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view
                         show:(BOOL)show
                     complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title
                show:(BOOL)show
            complete:(void(^)())complete {
    
    CGSize size = [self calculateTitleSize:title.string];
    CGFloat sizeWidth = (size.width < (self.width / _numOfMenu) - 25) ? size.width : self.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator
             background:(UIView *)background
          leftTableView:(UITableView *)leftTableView
         rightTableView:(UITableView *)rightTableView
                  title:(CATextLayer *)title
                forward:(BOOL)forward
              complecte:(void(^)())complete{
    
    [self animateIndicator:indicator forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:^{
                }];
            }];
        }];
    }];
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator
             background:(UIView *)background
         collectionView:(UICollectionView *)collectionView
                  title:(CATextLayer *)title
                forward:(BOOL)forward
              complecte:(void(^)())complete{
    
    [self animateIndicator:indicator forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateCollectionView:collectionView show:forward complete:^{
                }];
            }];
        }];
    }];
    complete();
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PGCDropMenuCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kPGCCollectionViewCell = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPGCCollectionViewCell forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

//- (void)confiMenuWithSelectRow:(NSInteger)row {
//    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
//    title.string = [self.dataSource menu:self titleForRowAtIndexPath:[PGCIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:row]];
//    
//    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
//        _show = NO;
//    }];
//    
//    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
//    
//    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
//    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
//}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width - 2) / 3, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 1, 0.5);
}



#pragma mark - Getter

- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}


#pragma mark - Setter
- (void)setDataSource:(id<PGCDropMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.width / (_numOfMenu * 2);
    CGFloat separatorLineInterval = self.width / _numOfMenu;
    CGFloat bgLayerInterval = self.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
#pragma mark *** bgLayer ***
        CGPoint bgLayerPosition = CGPointMake((i + 0.5) * bgLayerInterval, self.height / 2);
        CALayer *bgLayer = [self createBgLayerWithColor:BackColor position:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        
#pragma mark *** title ***
        CGPoint titlePosition = CGPointMake((i * 2 + 1) * textLayerInterval , self.height / 2);
        NSString *titleString = [_dataSource menu:self titleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString color:self.textColor position:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        
#pragma mark *** indicator ***
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor position:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, self.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
#pragma mark *** separator ***
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor position:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}


#pragma mark - Setter Support

- (CALayer *)createBgLayerWithColor:(UIColor *)color
                        position:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.width / self.numOfMenu, self.height - 1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color
                               position:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = PGCTextColor.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color
                                   position:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160, 0)];
    [path addLineToPoint:CGPointMake(160, self.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string
                                   color:(UIColor *)color
                                 position:(CGPoint)point {
    
    CGSize size = [self calculateTitleSize:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.width / _numOfMenu) - 25) ? size.width : self.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = PGCTextColor.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSize:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}


@end
