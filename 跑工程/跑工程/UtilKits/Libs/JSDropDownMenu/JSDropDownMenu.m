//
//  JSDropDownMenu.m
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import "JSDropDownMenu.h"

#define FontSize [UIFont systemFontOfSize:14.0]

#define TextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define SelectColor [UIColor colorWithRed:250/255.0 green:117/255.0 blue:10/255.0 alpha:1.0]
#define BackColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define SeparatorColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1.0]
#define DetailColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]

static NSString *const kJSCollectionViewCell = @"JSCollectionViewCell";
@interface JSCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *textLabel;
@end

@implementation JSCollectionViewCell
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
    CGFloat width = self.contentView.frame.size.width - 20;
    CGFloat height = self.contentView.frame.size.height - 20;
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, width, height)];
    centerView.backgroundColor = SeparatorColor;
    [self.contentView addSubview:centerView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = DetailColor;
    self.textLabel.font = FontSize;
    [centerView addSubview:self.textLabel];
    self.textLabel.sd_layout
    .centerYEqualToView(centerView)
    .leftSpaceToView(centerView, 15)
    .rightSpaceToView(centerView, 5)
    .autoHeightRatio(0);
}
@end

@implementation JSIndexPath
- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight  leftRow:(NSInteger)leftRow row:(NSInteger)row
{
    self = [super init];
    if (self) {
        _column = column;
        _leftOrRight = leftOrRight;
        _leftRow = leftRow;
        _row = row;
    }
    return self;
}
+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row
{
    JSIndexPath *indexPath = [[self alloc] initWithColumn:col leftOrRight:leftOrRight leftRow:leftRow row:row];
    return indexPath;
}
@end

#pragma mark - menu implementation

@interface JSDropDownMenu () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *bottomShadow;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
//data source
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;
@property (nonatomic, assign) NSInteger leftSelectedRow;
@property (nonatomic, assign) BOOL hadSelected;

@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;
@end

@implementation JSDropDownMenu


- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

- (void)reloadData
{
    [self.leftTableView reloadData];
    
    if ([self.dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex]) {
        [self.rightTableView reloadData];
    }
    if ([self.dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex]) {
        [self.collectionView reloadData];
    }
}


#pragma mark -
#pragma mark - setter

- (void)setDataSource:(id<JSDropDownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    self.titleLabels = [NSMutableArray array];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake((i * 2 + 1) * textLayerInterval, self.frame.size.height/2);
        NSString *titleString = [_dataSource menu:self titleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString position:titlePosition];
        [self.layer addSublayer:title];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titleString;
        titleLabel.textColor = TextColor;
        titleLabel.font = FontSize;
        [self addSubview:titleLabel];
        [self.titleLabels addObject:titleLabel];
        
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithPosition:CGPointMake(titlePosition.x + title.bounds.size.width/2 + 10, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        //separator
         if (i != _numOfMenu - 1) {
             CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height/2);
             CAShapeLayer *separator = [self createSeparatorLineWithPosition:separatorPosition];
             [self.layer addSublayer:separator];
         }
    }
    _bottomShadow.backgroundColor = BackColor;
    
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}


#pragma mark -
#pragma mark - init method

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        
        _hadSelected = NO;
        
        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = 45;
        _leftTableView.separatorColor = SeparatorColor;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStylePlain];
        _rightTableView.rowHeight = 45;
        _rightTableView.separatorColor = SeparatorColor;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width / 3 - 1, 65);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:kJSCollectionViewCell];
        
        self.autoresizesSubviews = NO;
        _leftTableView.autoresizesSubviews = NO;
        _rightTableView.autoresizesSubviews = NO;
        _collectionView.autoresizesSubviews = NO;
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        _bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        [self addSubview:_bottomShadow];
    }
    return self;
}


#pragma mark -
#pragma mark - init support

- (CALayer *)createBgLayerWithPosition:(CGPoint)position
{
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}

- (CAShapeLayer *)createIndicatorWithPosition:(CGPoint)point
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = TextColor.CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithPosition:(CGPoint)point
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height)];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = BackColor.CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string position:(CGPoint)point
{
    CGSize size = [string sizeWithFont:FontSize constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    CATextLayer *layer = [[CATextLayer alloc] init];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 40) ? size.width : self.frame.size.width / _numOfMenu - 40;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = [UIColor clearColor].CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    return layer;
}



#pragma mark -
#pragma mark - gesture handle

- (void)menuTapped:(UITapGestureRecognizer *)paramSender
{
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
            self.titleLabels[i].textColor = TextColor;
        }
    }
    
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:tapIndex];
    }
    
    if (displayByCollectionView) {
        
        UICollectionView *collectionView = _collectionView;
        
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
            self.titleLabels[tapIndex].textColor = TextColor;
        } else {
            
            _currentSelectedMenudIndex = tapIndex;
            
            [_collectionView reloadData];
            
            if (_currentSelectedMenudIndex!=-1) {
                // 需要隐藏tableview
                [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:NO complete:^{
                    
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            } else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            self.titleLabels[tapIndex].textColor = SelectColor;
        }
        
    } else{
        
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:tapIndex];

        UITableView *rightTableView = nil;
        
        if (haveRightTableView) {
            rightTableView = _rightTableView;
            // 修改左右tableview显示比例
        }
        
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
            self.titleLabels[tapIndex].textColor = TextColor;
        } else {
            
            _hadSelected = NO;
            
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
                [self animateCollectionView:_collectionView show:NO complete:^{
                    
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
                
            } else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            self.titleLabels[tapIndex].textColor = SelectColor;
        }
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender {
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex];
    }
    if (displayByCollectionView) {
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        
    } else{
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }
    self.titleLabels[_currentSelectedMenudIndex].textColor = TextColor;
}


#pragma mark -
#pragma mark - animation method

- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete
{
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
    indicator.fillColor = forward ? SelectColor.CGColor : TextColor.CGColor;
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}


- (void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show complete:(void(^)())complete
{
    CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat y = self.frame.origin.y;
    
    if (show) {
        CGFloat leftTableViewHeight = 0;
        CGFloat rightTableViewHeight = 0;
        
        if (leftTableView) {
            leftTableView.frame = CGRectMake(_origin.x, y + height, width * ratio, 0);
            [self.superview addSubview:leftTableView];
            leftTableViewHeight = ([leftTableView numberOfRowsInSection:0] > 7) ? (7 * leftTableView.rowHeight) : ([leftTableView numberOfRowsInSection:0] * leftTableView.rowHeight);
        }
        
        if (rightTableView) {
            rightTableView.frame = CGRectMake(_origin.x + leftTableView.frame.size.width, y + height, width * (1 - ratio), 0);
            [self.superview addSubview:rightTableView];
            rightTableViewHeight = ([rightTableView numberOfRowsInSection:0] > 7) ? (7 * rightTableView.rowHeight) : ([rightTableView numberOfRowsInSection:0] * rightTableView.rowHeight);
        }
        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        
        [UIView animateWithDuration:0.25 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, y + height, width * ratio, tableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, y + height, width * (1 - ratio), tableViewHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, y + height, width * ratio, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, y + height, width * (1 - ratio), 0);
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


- (void)animateCollectionView:(UICollectionView *)collectionView show:(BOOL)show complete:(void(^)())complete
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat y = self.frame.origin.y;
    
    if (show) {
        
        CGFloat collectionViewHeight = 0;
        
        if (collectionView) {
            
            collectionView.frame = CGRectMake(_origin.x, y + height, width, 0);
            [self.superview addSubview:collectionView];
            
            NSInteger number = [collectionView numberOfItemsInSection:0];
            // 根据item的个数来计算集合视图的高度
            collectionViewHeight = ((number % 3) > 0) ? (number / 3 + 1) * 65 : number / 3 * 65;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, y + height, width, collectionViewHeight + 10);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, y + height, width, 0);
            }
        } completion:^(BOOL finished) {
            if (collectionView) {
                [collectionView removeFromSuperview];
            }
        }];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete
{
    CGSize size = [(NSString *)title.string sizeWithFont:FontSize constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 40) ? size.width : self.frame.size.width / _numOfMenu - 40;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete
{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:^{
                    
                }];
            }];
        }];
    }];
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background collectionView:(UICollectionView *)collectionView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete
{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateCollectionView:collectionView show:forward complete:^{
                    
                }];                
            }];
        }];
    }];
    complete();
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger leftOrRight = 0;
    
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    }
    
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight: leftRow:)]) {
        return [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DropDownMenuCell";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = SeparatorColor;
        
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TextColor;
    titleLabel.font = FontSize;
    [cell addSubview:titleLabel];
    
    UIImage *image = [UIImage imageNamed:@"选中-对号"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = CGPointMake(image.size.width, cell.frame.size.height / 2);
    
    NSInteger leftOrRight = 0;
    if (_rightTableView == tableView) {
        leftOrRight = 1;
    }
    
    CGFloat textWidth = 0;
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        titleLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row]];
        // 只取宽度
        textWidth = [titleLabel.text sizeWithFont:FontSize constrainedToSize:CGSizeMake(MAXFLOAT, 14)].width;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = FontSize;
    cell.separatorInset = UIEdgeInsetsZero;    
    
    titleLabel.frame = CGRectMake(imageView.right_sd + 8, 0, textWidth, cell.frame.size.height);
    
    if (leftOrRight == 1) {
        //右边tableview
        cell.backgroundColor = BackColor;
        
        if ([titleLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
            [cell addSubview:imageView];
            
            titleLabel.textColor = SelectColor;
            cell.backgroundColor = SeparatorColor;
        }
    }
    else {
        // 是否为选中的cell
        if (!_hadSelected && _leftSelectedRow == indexPath.row) {
            titleLabel.textColor = SelectColor;
            cell.backgroundColor = BackColor;
            
            if (![_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex]) {                
                [cell addSubview:imageView];
            }
        }
    }
    return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger leftOrRight = 0;
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    } else {
        _leftSelectedRow = indexPath.row;
    }
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex];
        
        JSIndexPath *jsIndexPath = [JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row];
        
        if ((leftOrRight==0 && !haveRightTableView) || leftOrRight==1) {
            
            CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
            
            title.string = [self.dataSource menu:self titleForRowAtIndexPath:jsIndexPath];
            
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _show = NO;
            }];
            self.titleLabels[_currentSelectedMenudIndex].textColor = TextColor;
        }
        
        [self.delegate menu:self didSelectRowAtIndexPath:jsIndexPath];
        
        if (leftOrRight==0 && haveRightTableView) {
            if (!_hadSelected) {
                _hadSelected = YES;
                [_leftTableView reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelectedRow inSection:0];
                
                [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            [_rightTableView reloadData];
            if ([_rightTableView numberOfRowsInSection:0] < 1) {
                [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                    _show = NO;
                }];
                self.titleLabels[_currentSelectedMenudIndex].textColor = TextColor;
            }
        }        
    }
}


#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 为collectionview时 leftOrRight 为-1
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight: leftRow:)]) {
        return [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    JSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJSCollectionViewCell forIndexPath:indexPath];
    
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:indexPath.row]];
    }
    if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
        cell.textLabel.textColor = SelectColor;
    } else {
        cell.textLabel.textColor = DetailColor;
    }
    return cell;
}


#pragma mark -
#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        
        JSIndexPath *jsIndexPath = [JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:indexPath.row];
        
        CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
        
        title.string = [self.dataSource menu:self titleForRowAtIndexPath:jsIndexPath];
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        
        self.titleLabels[_currentSelectedMenudIndex].textColor = TextColor;
        
        [self.delegate menu:self didSelectRowAtIndexPath:jsIndexPath];
    }
}


@end
