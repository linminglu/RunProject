//
//  DropDownMenu.m
//  跑工程
//
//  Created by leco on 2016/11/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "DropDownMenu.h"

@implementation IndexPath
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
        _item = -1;
    }
    return self;
}

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row tem:(NSInteger)item {
    self = [self initWithColumn:column row:row];
    if (self) {
        _item = item;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row {
    IndexPath *indexPath = [[self alloc] initWithColumn:col row:row];
    return indexPath;
}

+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row item:(NSInteger)item
{
    return [[self alloc]initWithColumn:col row:row tem:item];
}

@end

@implementation BackgroundCellView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条底部线
    
    CGContextSetRGBStrokeColor(context, 219.0/255.0, 219.0/255.0, 229.0/255.0, 1.0);//线条颜色
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width,0);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}

@end

#pragma mark - menu implementation

@interface DropDownMenu ()
{
    struct {
        unsigned int numberOfRowsInColumn :1;
        unsigned int numberOfItemsInRow :1;
        unsigned int titleForRowAtIndexPath :1;
        unsigned int titleForItemsInRowAtIndexPath :1;
        unsigned int imageNameForRowAtIndexPath :1;
        unsigned int imageNameForItemsInRowAtIndexPath :1;
        unsigned int detailTextForRowAtIndexPath: 1;
        unsigned int detailTextForItemsInRowAtIndexPath: 1;
        
    }_dataSourceFlags;
}

@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;  // 当前选中列

@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UITableView *leftTableView;   // 一级列表
@property (nonatomic, strong) UITableView *rightTableView;  // 二级列表
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UIView *bottomShadow;

//data source
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;

@end

#define kTableViewCellHeight 45
#define kTableViewHeight 300

#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kDetailTextColor [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1]
#define kSeparatorColor [UIColor colorWithRed:229/255.0 green:229/255.0 blue:239/255.0 alpha:1]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define kTextSelectColor [UIColor colorWithRed:250/255.0 green:117/255.0 blue:10/255.0 alpha:1]

static NSString *const kCollectionViewCell = @"CollectionViewCell";

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = self.contentView.frame.size.width - 20;
        CGFloat height = self.contentView.frame.size.height - 20;
        
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, width, height)];
        centerView.backgroundColor = kSeparatorColor;
        [self.contentView addSubview:centerView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = kDetailTextColor;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        [centerView addSubview:self.textLabel];
        self.textLabel.sd_layout
        .centerYEqualToView(centerView)
        .leftSpaceToView(centerView, 15)
        .rightSpaceToView(centerView, 5)
        .autoHeightRatio(0);
    }
    return self;
}

@end

@implementation DropDownMenu

#pragma mark - getter
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

- (NSString *)titleForRowAtIndexPath:(IndexPath *)indexPath
{
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

- (void)reloadData
{
    [self animateBackGroundView:_backGroundView show:NO complete:^{
        [self animateTableView:nil show:NO complete:^{
            _show = NO;
            id dataSource = self.dataSource;
            self.dataSource = nil;
            self.dataSource = dataSource;
        }];
    }];
    
}

- (void)selectDefalutIndexPath
{
    [self selectIndexPath:[IndexPath indexPathWithCol:0 row:0]];
}

- (void)selectIndexPath:(IndexPath *)indexPath
{
    [self selectIndexPath:indexPath triggerDelegate:YES];
}

- (void)selectIndexPath:(IndexPath *)indexPath triggerDelegate:(BOOL)trigger
{
    if (!_dataSource || !_delegate
        || ![_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        return;
    }
    
    if ([_dataSource numberOfColumnsInMenu:self] <= indexPath.column || [_dataSource menu:self numberOfRowsInColumn:indexPath.column] <= indexPath.row) {
        return;
    }
    
    CATextLayer *title = (CATextLayer *)_titles[indexPath.column];
    
    if (indexPath.item < 0) {
        if (!_isClickHaveItemValid && [_dataSource menu:self numberOfItemsInRow:indexPath.row column:indexPath.column] > 0) {
            
            title.string = [_dataSource menu:self titleForItemsInRowAtIndexPath:[IndexPath indexPathWithCol:indexPath.column row:self.isRemainMenuTitle ? 0 : indexPath.row item:0]];
            
            if (trigger) {
                [_delegate menu:self didSelectRowAtIndexPath:[IndexPath indexPathWithCol:indexPath.column row:indexPath.row item:0]];
            }
            
        } else {
            title.string = [_dataSource menu:self titleForRowAtIndexPath:
                            [IndexPath indexPathWithCol:indexPath.column row:self.isRemainMenuTitle ? 0 : indexPath.row]];
            
            if (trigger) {
                [_delegate menu:self didSelectRowAtIndexPath:indexPath];
            }
        }
        if (_currentSelectRowArray.count > indexPath.column) {
            
            _currentSelectRowArray[indexPath.column] = @(indexPath.row);
        }
        
        CGSize size = [self calculateTitleSizeWithString:title.string];
        
        CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
        
        title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
        
    }
    else if ([_dataSource menu:self numberOfItemsInRow:indexPath.row column:indexPath.column] > indexPath.column) {
        
        title.string = [_dataSource menu:self titleForItemsInRowAtIndexPath:indexPath];
        
        if (trigger) {
            [_delegate menu:self didSelectRowAtIndexPath:indexPath];
        }
        
        if (_currentSelectRowArray.count > indexPath.column) {
            
            _currentSelectRowArray[indexPath.column] = @(indexPath.row);
        }
        CGSize size = [self calculateTitleSizeWithString:title.string];
        
        CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
        
        title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    }
}


#pragma mark - setter
- (void)setDataSource:(id<DropDownMenuDataSource>)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    _currentSelectRowArray = [NSMutableArray arrayWithCapacity:_numOfMenu];
    
    for (NSInteger index = 0; index < _numOfMenu; ++index) {
        [_currentSelectRowArray addObject:@(0)];
    }
    
    _dataSourceFlags.numberOfRowsInColumn = [_dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:)];
    _dataSourceFlags.numberOfItemsInRow = [_dataSource respondsToSelector:@selector(menu:numberOfItemsInRow:column:)];
    _dataSourceFlags.titleForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)];
    _dataSourceFlags.titleForItemsInRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:titleForItemsInRowAtIndexPath:)];
    _dataSourceFlags.imageNameForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:imageNameForRowAtIndexPath:)];
    _dataSourceFlags.imageNameForItemsInRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:imageNameForItemsInRowAtIndexPath:)];
    _dataSourceFlags.detailTextForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:detailTextForRowAtIndexPath:)];
    _dataSourceFlags.detailTextForItemsInRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:detailTextForItemsInRowAtIndexPath:)];
    
    _bottomShadow.hidden = NO;
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor] andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        
        NSString *titleString;
        if (!self.isClickHaveItemValid && _dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:0 column:i]>0) {
            titleString = [_dataSource menu:self titleForItemsInRowAtIndexPath:[IndexPath indexPathWithCol:i row:0 item:0]];
        }else {
            titleString =[_dataSource menu:self titleForRowAtIndexPath:[IndexPath indexPathWithCol:i row:0]];
        }
        
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake((i + 1)*separatorLineInterval - 10, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
        //separator
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake(ceilf((i + 1) * separatorLineInterval-1), self.frame.size.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        _fontSize = 14;
        _cellStyle = UITableViewCellStyleValue1;
        _separatorColor = kSeparatorColor;
        _textColor = kTextColor;
        _textSelectedColor = kTextSelectColor;
        _detailTextFont = [UIFont systemFontOfSize:11];
        _detailTextColor = kDetailTextColor;
        _indicatorColor = kTextColor;
        _isClickHaveItemValid = YES;
        
        //lefttableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = kTableViewCellHeight;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorColor = kSeparatorColor;
        _leftTableView.separatorInset = UIEdgeInsetsZero;
        _leftTableView.tableFooterView = [[UIView alloc]init];
        
        //righttableView init
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0) style:UITableViewStylePlain];
        _rightTableView.rowHeight = kTableViewCellHeight;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorColor = kSeparatorColor;
        _rightTableView.separatorInset = UIEdgeInsetsZero;
        
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width / 3 - 1, 65);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCell];
        
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
        
        //add top shadow
        UIView *topShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 0.5)];
        topShadow.backgroundColor = kSeparatorColor;
        [self addSubview:topShadow];
        
        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = kSeparatorColor;
        bottomShadow.hidden = YES;
        [self addSubview:bottomShadow];
        _bottomShadow = bottomShadow;
    }
    return self;
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = _fontSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.truncationMode = kCATruncationEnd;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    //CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:_fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return CGSizeMake(ceilf(size.width)+2, size.height);
}

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    if (_dataSource == nil) {
        return;
    }
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
        }
    }
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:tapIndex];
    }
    
    if (displayByCollectionView) {
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
        } else {
            _currentSelectedMenudIndex = tapIndex;
            [_collectionView reloadData];
            
            if (_currentSelectedMenudIndex != -1) {
                [self animateTableView:_leftTableView show:NO complete:^{
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:_collectionView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            } else {
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:_collectionView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
        }
    } else {
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
        } else {
            _currentSelectedMenudIndex = tapIndex;
            [_leftTableView reloadData];
            if (_dataSource && _dataSourceFlags.numberOfItemsInRow) {
                [_rightTableView reloadData];
            }
            
            if (_currentSelectedMenudIndex != -1) {
                [self animateCollectionView:_collectionView show:NO complete:^{
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_leftTableView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            } else {
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_leftTableView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
        }
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex];
    }
    if (displayByCollectionView) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    } else {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }
}

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
    
    if (forward) {
        // 展开
        indicator.fillColor = _textSelectedColor.CGColor;
    } else {
        // 收缩
        indicator.fillColor = _textColor.CGColor;
    }
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
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

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat y = self.frame.origin.y;
    
    BOOL haveItems = NO;
    
    if (_dataSource) {
        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        
        for (NSInteger i = 0; i<num;++i) {
            if (_dataSourceFlags.numberOfItemsInRow
                && [_dataSource menu:self numberOfItemsInRow:i column:_currentSelectedMenudIndex] > 0) {
                haveItems = YES;
                break;
            }
        }
    }
    
    if (show) {
        if (haveItems) {
            _leftTableView.frame = CGRectMake(self.origin.x, y + height, width/2, 0);
            _rightTableView.frame = CGRectMake(self.origin.x + width/2, y + height, width/2, 0);
            [self.superview addSubview:_leftTableView];
            [self.superview addSubview:_rightTableView];
        } else {
            _leftTableView.frame = CGRectMake(self.origin.x, y + height, width, 0);
            _rightTableView.frame = CGRectMake(self.origin.x + width/2, y + height, width/2, 0);
            [self.superview addSubview:_leftTableView];
            
        }
        
        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        CGFloat tableViewHeight = num * kTableViewCellHeight > kTableViewHeight+1 ? kTableViewHeight:num*kTableViewCellHeight+1;
        
        [UIView animateWithDuration:0.2 animations:^{
            if (haveItems) {
                _leftTableView.frame = CGRectMake(self.origin.x, y + height, width/2, tableViewHeight);
                
                _rightTableView.frame = CGRectMake(self.origin.x + width/2, y + height, width/2, tableViewHeight);
            } else {
                _leftTableView.frame = CGRectMake(self.origin.x, y + height, width, tableViewHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if (haveItems) {
                _leftTableView.frame = CGRectMake(self.origin.x, y + height, width/2, 0);
                
                _rightTableView.frame = CGRectMake(self.origin.x + width/2, y + height, width/2, 0);
            } else {
                _leftTableView.frame = CGRectMake(self.origin.x, y + height, width, 0);
            }
        } completion:^(BOOL finished) {
            if (_rightTableView.superview) {
                [_rightTableView removeFromSuperview];
            }
            [_leftTableView removeFromSuperview];
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
            
            collectionView.frame = CGRectMake(self.origin.x, y + height, width, 0);
            [self.superview addSubview:collectionView];
            
            NSInteger number = [collectionView numberOfItemsInSection:0];
            // 根据item的个数来计算集合视图的高度
            collectionViewHeight = ((number % 3) > 0) ? (number / 3 + 1) * 65 : number / 3 * 65;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(self.origin.x, y + height, width, collectionViewHeight + 10);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (collectionView) {
                collectionView.frame = CGRectMake(self.origin.x, y + height, width, 0);
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
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    if (!show) {
        title.foregroundColor = _textColor.CGColor;
    } else {
        title.foregroundColor = _textSelectedColor.CGColor;
    }
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete
{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
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

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSAssert(_dataSource != nil, @"menu's dataSource shouldn't be nil");
    if (_leftTableView == tableView) {
        if (_dataSourceFlags.numberOfRowsInColumn) {
            return [_dataSource menu:self
                numberOfRowsInColumn:_currentSelectedMenudIndex];
        } else {
            //NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    } else {
        if (_dataSourceFlags.numberOfItemsInRow) {
            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
            return [_dataSource menu:self
                  numberOfItemsInRow:currentSelectedMenudRow column:_currentSelectedMenudIndex];
        } else {
            //NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:_cellStyle reuseIdentifier:identifier];
        //cell.separatorInset = UIEdgeInsetsZero;
        BackgroundCellView *bg = [[BackgroundCellView alloc]init];
        bg.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = bg;
        cell.textLabel.highlightedTextColor = _textSelectedColor;
        cell.textLabel.textColor = _textColor;
        cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
        if (_dataSourceFlags.detailTextForRowAtIndexPath || _dataSourceFlags.detailTextForItemsInRowAtIndexPath) {
            cell.detailTextLabel.textColor = _detailTextColor;
            cell.detailTextLabel.font = _detailTextFont;
        }
    }
    //NSAssert(_dataSource != nil, @"menu's datasource shouldn't be nil");
    if (tableView == _leftTableView) {
        if (_dataSourceFlags.titleForRowAtIndexPath) {
            
            cell.textLabel.text = [_dataSource menu:self titleForRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
            
            if (_dataSourceFlags.imageNameForRowAtIndexPath) {
                
                NSString *imageName = [_dataSource menu:self imageNameForRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
                
                if (imageName && imageName.length > 0) {
                    cell.imageView.image = [UIImage imageNamed:imageName];
                } else {
                    cell.imageView.image = nil;
                }
                
            } else {
                cell.imageView.image = nil;
            }
            
            if (_dataSourceFlags.detailTextForRowAtIndexPath) {
                NSString *detailText = [_dataSource menu:self detailTextForRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
                cell.detailTextLabel.text = detailText;
            }else {
                cell.detailTextLabel.text = nil;
            }
            
        } else {
            //NSAssert(0 == 1, @"dataSource method needs to be implemented");
        }
        
        NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
        if (indexPath.row == currentSelectedMenudRow) {
            
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        if (_dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:indexPath.row column:_currentSelectedMenudIndex]> 0) {
            UIImage *nor_image = [UIImage imageNamed:@"icon_chose_arrow_nor"];
            UIImage *sel_image = [UIImage imageNamed:@"icon_chose_arrow_sel"];
            cell.accessoryView = [[UIImageView alloc] initWithImage:nor_image highlightedImage:sel_image];
        } else {
            cell.accessoryView = nil;
        }
        cell.backgroundColor = kCellBgColor;
        
    } else {
        if (_dataSourceFlags.titleForItemsInRowAtIndexPath) {
            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
            cell.textLabel.text = [_dataSource menu:self titleForItemsInRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
            
            if (_dataSourceFlags.imageNameForItemsInRowAtIndexPath) {
                NSString *imageName = [_dataSource menu:self imageNameForItemsInRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
                
                if (imageName && imageName.length > 0) {
                    cell.imageView.image = [UIImage imageNamed:imageName];
                } else {
                    cell.imageView.image = nil;
                }
            } else {
                cell.imageView.image = nil;
            }
            if (_dataSourceFlags.detailTextForItemsInRowAtIndexPath) {
                NSString *detailText = [_dataSource menu:self detailTextForItemsInRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
                cell.detailTextLabel.text = detailText;
            } else {
                cell.detailTextLabel.text = nil;
            }
            
        } else {
            //NSAssert(0 == 1, @"dataSource method needs to be implemented");
        }
        if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
            [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectedMenudRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [_rightTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryView = nil;
    }
    
    return cell;
}


#pragma mark - tableview delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [_delegate respondsToSelector:@selector(menu:willSelectRowAtIndexPath:)]) {
        return [self.delegate menu:self willSelectRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
    } else {
        //TODO: delegate is nil
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView) {
        
        BOOL haveItem = [self confiMenuWithSelectRow:indexPath.row];
        
        BOOL isClickHaveItemValid = self.isClickHaveItemValid ? YES : haveItem;
        
        if (isClickHaveItemValid && _delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
            [self.delegate menu:self didSelectRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
        } else {
            //TODO: delegate is nil
        }
    } else {
        [self confiMenuWithSelectItem:indexPath.item];
        if (self.delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
            [self.delegate menu:self didSelectRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
        } else {
            //TODO: delegate is nil
        }
    }
}

- (BOOL)confiMenuWithSelectRow:(NSInteger)row
{
    _currentSelectRowArray[_currentSelectedMenudIndex] = @(row);
    
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    
    if (_dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:row column:_currentSelectedMenudIndex]> 0) {
        
        // 有双列表 有item数据
        if (self.isClickHaveItemValid) {
            title.string = [_dataSource menu:self titleForRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:row]];
            [self animateTitle:title show:YES complete:^{
                [_rightTableView reloadData];
            }];
        } else {
            [_rightTableView reloadData];
        }
        return NO;
        
    } else {
        
        title.string = [_dataSource menu:self titleForRowAtIndexPath:
                        [IndexPath indexPathWithCol:_currentSelectedMenudIndex row:self.isRemainMenuTitle ? 0 : row]];
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        return YES;
    }
}

- (void)confiMenuWithSelectItem:(NSInteger)item
{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
    title.string = [_dataSource menu:self titleForItemsInRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:item]];
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    
}


#pragma mark - collection datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataSourceFlags.numberOfRowsInColumn) {
        return [_dataSource menu:self numberOfRowsInColumn:_currentSelectedMenudIndex];
    } else{
        //NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
    
    if (_dataSourceFlags.titleForRowAtIndexPath) {
        cell.textLabel.text = [_dataSource menu:self titleForRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.item]];
    } else {
        //NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
        
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        cell.textLabel.textColor = kTextSelectColor;
        
    } else {
        cell.textLabel.textColor = kTextColor;
    }
    return cell;
}


#pragma mark - collection delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self confiCollectWithSelectItem:indexPath.item];
    if (self.delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [self.delegate menu:self didSelectRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.item]];
    } else {
        //TODO: delegate is nil
    }
}

- (void)confiCollectWithSelectItem:(NSInteger)item
{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    
    title.string = [_dataSource menu:self titleForItemsInRowAtIndexPath:[IndexPath indexPathWithCol:_currentSelectedMenudIndex row:item]];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
}


@end
