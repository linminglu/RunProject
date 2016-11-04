//
//  PGCDropMenu.m
//  跑工程
//
//  Created by leco on 2016/10/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCDropMenu.h"
#import "PGCDropMenu+Custom.h"
#import "PGCDropLeftCell.h"
#import "PGCDropRightCell.h"
#import "PGCDropCenterCell.h"
#import "PGCCollectionViewCell.h"


@interface PGCDropMenu () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
/**
 半透明背景
 */
@property (strong, nonatomic) UIView *backgroundView;
/**
 左边表格视图
 */
@property (strong, nonatomic) UITableView *leftTable;
/**
 右边表格视图
 */
@property (strong, nonatomic) UITableView *rightTable;
/**
 中间表格视图
 */
@property (strong, nonatomic) UITableView *centerTable;
/**
 集合视图
 */
@property (strong, nonatomic) UICollectionView *collectionView;

/**
 相对于父视图的坐标
 */
@property (assign, nonatomic) CGPoint origin;
/**
 是否显示下拉菜单
 */
@property (assign, nonatomic, getter=isShow) BOOL show;
/**
 当前选中的菜单按钮下标
 */
@property (assign, nonatomic) NSInteger currentIndex;
/**
 是否选中
 */
@property (assign, nonatomic) BOOL isSelected;
/**
 选中左边表的行数
 */
@property (nonatomic, assign) NSInteger leftSelectedRow;

// 菜单栏的layer数组
@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray *indicators;
@property (copy, nonatomic) NSArray *bgLayers;


@end

@implementation PGCDropMenu

- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    
    if (self) {
        self.origin = origin;
        self.currentIndex = -1;
        self.isSelected = false;
        self.show = false;
        
        [self createUI:origin];
    }
    return self;
}

- (void)createUI:(CGPoint)origin {
    self.backgroundColor = [UIColor whiteColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTappedEvent:)]];
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y + self.frame.size.height, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.backgroundView.opaque = false;
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTappedEvent:)]];
    
    self.leftTable = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStylePlain];
    self.leftTable.backgroundColor = [UIColor whiteColor];
    self.leftTable.rowHeight = 45;
    self.leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTable.dataSource = self;
    self.leftTable.delegate = self;
    [self.leftTable registerClass:[PGCDropLeftCell class] forCellReuseIdentifier:kPGCDropLeftCell];
    
    self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStylePlain];
    self.rightTable.backgroundColor = RGB(240, 240, 240);
    self.rightTable.rowHeight = 45;
    self.rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTable.dataSource = self;
    self.rightTable.delegate = self;
    [self.rightTable registerClass:[PGCDropRightCell class] forCellReuseIdentifier:kPGCDropRightCell];
    
    self.centerTable = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStylePlain];
    self.centerTable.backgroundColor = [UIColor whiteColor];
    self.centerTable.rowHeight = 45;
    self.centerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.centerTable.dataSource = self;
    self.centerTable.delegate = self;
    [self.centerTable registerClass:[PGCDropCenterCell class] forCellReuseIdentifier:kPGCDropCenterCell];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width / 3 - 1, 65);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[PGCCollectionViewCell class] forCellWithReuseIdentifier:kPGCCollectionViewCell];
    
    
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, SCREEN_SIZE.width, 1)];
    bottomShadow.backgroundColor = RGB(200, 200, 200);
    [self addSubview:bottomShadow];
    
    self.autoresizesSubviews = false;
    self.leftTable.autoresizesSubviews = false;
    self.rightTable.autoresizesSubviews = false;
    self.centerTable.autoresizesSubviews = false;
    self.collectionView.autoresizesSubviews = false;
}


#pragma mark - Events

- (void)menuTappedEvent:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / self.dropTitles.count);
    
    for (int i = 0; i < self.dropTitles.count; i++) {
        if (i != tapIndex) {
            [self showIndicator:self.indicators[i] forward:false complete:^{
                
            }];
            [(CALayer *)self.bgLayers[i] setBackgroundColor:[UIColor whiteColor].CGColor];
        }
    }
    
    // 判断是否显示集合视图的下拉菜单
    BOOL haveCollectView = false;
    
    if ([self.dataSource respondsToSelector:@selector(displayCollectionViewInColumn:)]) {
        haveCollectView = [self.dataSource displayCollectionViewInColumn:tapIndex];
    }
    
    if (haveCollectView) {
        // 判断点击的按钮下标是否为当前已选的按钮的下标
        if (tapIndex == self.currentIndex && self.show) {
            [self showIndicator:self.indicators[self.currentIndex] background:self.backgroundView collectionView:self.collectionView forward:false complete:^{
                
                self.currentIndex = tapIndex;
                self.show = false;
            }];
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
        }
        // 显示当前点击的按钮对应的下拉菜单
        else {
            self.currentIndex = tapIndex;
            
            [self.collectionView reloadData];
            
            if (self.currentIndex != -1) {
                // 隐藏两个表格的下拉菜单
                [self showLeftTable:self.leftTable rightTable:self.rightTable show:false complete:^{
                    // 隐藏一个表格的下拉菜单
                    [self showCenterTable:self.centerTable show:false complete:^{
                        // 显示collectionView
                        [self showIndicator:self.indicators[tapIndex] background:self.backgroundView collectionView:self.collectionView forward:true complete:^{
                            
                            self.show = true;
                        }];
                    }];
                }];
            } else{
                [self showIndicator:self.indicators[tapIndex] background:self.backgroundView collectionView:self.collectionView forward:true complete:^{
                    
                    self.show = true;
                }];
            }
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:RGB(240, 240, 240).CGColor];
        }
    }
    // 不显示集合视图
    else {
        // 判断是否显示两个表格的下拉菜单
        if ([self.dataSource haveRightInColumn:tapIndex]) {
            
            // 判断点击的按钮下标是否为当前已选的按钮的下标
            if (tapIndex == self.currentIndex && self.show) {
                [self showIndicator:self.indicators[self.currentIndex] background:self.backgroundView leftTable:self.leftTable rightTable:self.rightTable forward:false complete:^{
                    
                    self.currentIndex = tapIndex;
                    self.show = false;
                }];
                [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
            }
            // 显示当前点击的按钮对应的下拉菜单
            else {
                self.isSelected = false;
                self.currentIndex = tapIndex;
                
                if ([self.dataSource respondsToSelector:@selector(currentLeftSelectedRow:)]) {
                    self.leftSelectedRow = [self.dataSource currentLeftSelectedRow:self.currentIndex];
                }
                [self.leftTable reloadData];
                [self.rightTable reloadData];
                
                if (self.leftTable) {
                    self.leftTable.frame = CGRectMake(self.leftTable.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 2, 0);
                }
                if (self.rightTable) {
                    self.rightTable.frame = CGRectMake(self.origin.x + self.leftTable.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 2, 0);
                }
                
                if (self.currentIndex != -1) {
                    // 隐藏collectionView
                    [self showCollectionView:self.collectionView show:false complete:^{
                        // 隐藏一个表格的下拉菜单
                        [self showCenterTable:self.centerTable show:false complete:^{
                            // 显示两个表格的下拉菜单
                            [self showIndicator:self.indicators[tapIndex] background:self.backgroundView leftTable:self.leftTable rightTable:self.rightTable forward:true complete:^{
                                
                                self.show = true;
                            }];
                        }];
                    }];
                }
                else {
                    [self showIndicator:self.indicators[tapIndex] background:self.backgroundView leftTable:self.leftTable rightTable:self.rightTable forward:true complete:^{
                        
                        self.show = true;
                    }];
                }
                [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:RGB(240, 240, 240).CGColor];
            }
        }
        // 只显示一个表格的下拉菜单
        else {
            // 判断点击的按钮下标是否为当前已选的按钮的下标
            if (tapIndex == self.currentIndex && self.show) {
                [self showIndicator:self.indicators[self.currentIndex] background:self.backgroundView centerTable:self.centerTable forward:false complete:^{
                    
                    self.currentIndex = tapIndex;
                    self.show = false;
                }];
                [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
            }
            // 显示当前点击的按钮对应的下拉菜单
            else {
                self.currentIndex = tapIndex;
                
                [self.centerTable reloadData];
                
                if (self.currentIndex != -1) {
                    // 隐藏两个表格的下拉菜单
                    [self showLeftTable:self.leftTable rightTable:self.rightTable show:false complete:^{
                        // 隐藏collectionView
                        [self showCollectionView:self.collectionView show:false complete:^{
                            // 显示一个表格的下拉菜单
                            [self showIndicator:self.indicators[tapIndex] background:self.backgroundView centerTable:self.centerTable forward:true complete:^{
                                
                                self.show = true;
                            }];
                        }];
                    }];
                } else{
                    [self showIndicator:self.indicators[tapIndex] background:self.backgroundView centerTable:self.centerTable forward:true complete:^{
                        
                        self.show = true;
                    }];
                }
                [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:RGB(240, 240, 240).CGColor];
            }
        }
    }
}


- (void)backgroundTappedEvent:(UITapGestureRecognizer *)gesture {
    // 判断是否显示集合视图的下拉菜单
    BOOL haveCollectView = false;
    
    if ([self.dataSource respondsToSelector:@selector(displayCollectionViewInColumn:)]) {
        haveCollectView = [self.dataSource displayCollectionViewInColumn:self.currentIndex];
    }
    
    if (haveCollectView) {
        
        [self showIndicator:self.indicators[self.currentIndex] background:self.backgroundView collectionView:self.collectionView forward:false complete:^{
            
            self.show = false;
        }];
    }
    else {
        if ([self.dataSource haveRightInColumn:self.currentIndex]) {
            
            [self showIndicator:self.indicators[self.currentIndex] background:self.backgroundView leftTable:self.leftTable rightTable:self.rightTable forward:false complete:^{
                
                self.show = false;
            }];
        }
        else {
        
            [self showIndicator:self.indicators[self.currentIndex] background:self.backgroundView centerTable:self.centerTable forward:false complete:^{
               
                self.show = false;
            }];
        }
    }
    [(CALayer *)self.bgLayers[self.currentIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger leftOrRight = 0;
    
    if (self.centerTable == tableView) {
        leftOrRight = 0;
    }
    if (self.leftTable == tableView) {
        leftOrRight = 1;
    }
    if (self.rightTable == tableView) {
        leftOrRight = 2;
    }
    
    if ([self.dataSource respondsToSelector:@selector(dropMenu:numberOfRowsInColumn:leftOrRight:leftSelectedRow:)]) {
        
        return [self.dataSource dropMenu:self numberOfRowsInColumn:self.currentIndex leftOrRight:leftOrRight leftSelectedRow:self.leftSelectedRow];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger leftOrRight = 0;
    
    if (self.centerTable == tableView) {
        leftOrRight = 0;
        
        PGCDropCenterCell *centerCell = [tableView dequeueReusableCellWithIdentifier:kPGCDropCenterCell];
        
        if ([self.dataSource respondsToSelector:@selector(dropMenu:titleForRowAtIndexPath:)]) {
            
            centerCell.centerTitleLabel.text = [self.dataSource dropMenu:self titleForRowAtIndexPath:[PGCIndexPath indexPathWithColumn:self.currentIndex leftOrRight:leftOrRight leftRow:self.leftSelectedRow row:indexPath.row]];
        }
        return centerCell;
    }
    
    if (self.leftTable == tableView) {
        leftOrRight = 1;
        
        PGCDropLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:kPGCDropLeftCell];
        
        if ([self.dataSource respondsToSelector:@selector(dropMenu:titleForRowAtIndexPath:)]) {
            
            leftCell.leftTitleLabel.text = [self.dataSource dropMenu:self titleForRowAtIndexPath:[PGCIndexPath indexPathWithColumn:self.currentIndex leftOrRight:leftOrRight leftRow:self.leftSelectedRow row:indexPath.row]];
        }
        return leftCell;
    }
    
    if (self.rightTable == tableView) {
        leftOrRight = 2;
        
        PGCDropRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:kPGCDropRightCell];
        
        if ([self.dataSource respondsToSelector:@selector(dropMenu:titleForRowAtIndexPath:)]) {
            
            rightCell.rightTitleLabel.text = [self.dataSource dropMenu:self titleForRowAtIndexPath:[PGCIndexPath indexPathWithColumn:self.currentIndex leftOrRight:leftOrRight leftRow:self.leftSelectedRow row:indexPath.row]];
        }
        return rightCell;
    }
    return [UITableViewCell new];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger leftOrRight = 0;
    
    if (self.centerTable == tableView) {
        leftOrRight = 0;
        self.leftSelectedRow = indexPath.row;
        
    }
    if (self.leftTable == tableView) {
        leftOrRight = 1;
        self.leftSelectedRow = indexPath.row;
        
    }
    if (self.rightTable == tableView) {
        leftOrRight = 2;
        
    }
    if (self.delegate || [self.delegate respondsToSelector:@selector(dropMenu:didSelectRowAtIndexPath:)]) {
        
        [self.delegate dropMenu:self didSelectRowAtIndexPath:[PGCIndexPath indexPathWithColumn:self.currentIndex leftOrRight:leftOrRight leftRow:self.leftSelectedRow row:indexPath.row]];
        
        BOOL haveRightTableView = [self.dataSource haveRightInColumn:self.currentIndex];
        
        if (leftOrRight == 1 && haveRightTableView) {
            if (!self.isSelected) {
                self.isSelected = true;
                [self.leftTable reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.leftSelectedRow inSection:0];
                
                [self.leftTable selectRowAtIndexPath:selectedIndexPath animated:false scrollPosition:UITableViewScrollPositionNone];
            }
            [self.rightTable reloadData];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 为collectionview时 leftOrRight 为-1
    if ([self.dataSource respondsToSelector:@selector(dropMenu:numberOfRowsInColumn:leftOrRight:leftSelectedRow:)]) {
        return [self.dataSource dropMenu:self numberOfRowsInColumn:self.currentIndex leftOrRight:-1 leftSelectedRow:-1];
        
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PGCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPGCCollectionViewCell forIndexPath:indexPath];
    
    if ([self.dataSource respondsToSelector:@selector(dropMenu:titleForRowAtIndexPath:)]) {
        cell.collectionLabel.text = [self.dataSource dropMenu:self titleForRowAtIndexPath:[PGCIndexPath indexPathWithColumn:self.currentIndex leftOrRight:-1 leftRow:-1 row:indexPath.row]];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate || [self.delegate respondsToSelector:@selector(dropMenu:didSelectRowAtIndexPath:)]) {
        
        [self.delegate dropMenu:self didSelectRowAtIndexPath:[PGCIndexPath indexPathWithColumn:self.currentIndex leftOrRight:-1 leftRow:-1 row:indexPath.row]];
    }
}


#pragma mark - Setter

- (void)setDataSource:(id<PGCDropMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    CGFloat textLayerInterval = self.width / (self.dropTitles.count * 2);
    CGFloat bgLayerInterval = self.width / self.dropTitles.count;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:self.dropTitles.count];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:self.dropTitles.count];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:self.dropTitles.count];
    
    for (int i = 0; i < self.dropTitles.count; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i + 0.5) * bgLayerInterval, self.height / 2);
        CALayer *bgLayer = [self createBgLayerWithPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        
        //title
        CGPoint textPosition = CGPointMake((i * 2 + 1) * textLayerInterval , self.height / 2);
        NSString *textString = self.dropTitles[i];
        CATextLayer *textLayer = [self createTextLayerWithString:textString position:textPosition];
        [self.layer addSublayer:textLayer];
        [tempTitles addObject:textLayer];
        
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithPosition:CGPointMake(textPosition.x + textLayer.bounds.size.width / 2 + 8, self.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
    }
    
    self.titles = [tempTitles copy];
    self.indicators = [tempIndicators copy];
    self.bgLayers = [tempBgLayers copy];
}

@end
