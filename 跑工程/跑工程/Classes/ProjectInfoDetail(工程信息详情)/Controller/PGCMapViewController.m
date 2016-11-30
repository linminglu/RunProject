//
//  PGCMapViewController.m
//  跑工程
//
//  Created by leco on 2016/11/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCMapViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "PGCProject.h"
#import "PGCAnnotationView.h"
#import "ProjectsAnnotation.h"
#import "CurrentAnnotation.h"
#import "SelectableOverlay.h"

@interface PGCMapViewController () <MAMapViewDelegate, AMapLocationManagerDelegate, AMapNaviDriveManagerDelegate>

@property (strong, nonatomic) MAMapView *mapView;/** 地图视图 */
@property (strong, nonatomic) UIButton *gpsButton;/** GPS定位按钮 */
@property (strong, nonatomic) UIView *zoomPannelView;/** 比例缩放 */
@property (strong, nonatomic) NSMutableArray *annotations;/** 项目标注数组 */
@property (strong, nonatomic) AMapLocationManager *locationManager;/** 定位管理 */
@property (strong, nonatomic) AMapNaviDriveManager *driveManager;/** 导航管理 */
@property (strong, nonatomic) AMapNaviDriveView *driveView;/** 导航视图 */
@property (strong, nonatomic) NSMutableArray *routeIndicatorInfoArray;/** 导航路径 */
@property (strong, nonatomic) AMapNaviPoint *startPoint;
@property (strong, nonatomic) AMapNaviPoint *endPoint;

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}


- (void)initializeUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 把地图添加至view
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.gpsButton];
    [self.view addSubview:self.zoomPannelView];
    // 开始定位
    [self startSerialLocation];
    // 添加项目标注
    [self.mapView addAnnotations:self.annotations];
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CurrentAnnotation class]]) {
        
        MAPinAnnotationView *pinView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotation"];
        if (!pinView) {
            pinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotation"];
            pinView.pinColor = MAPinAnnotationColorRed;
            pinView.animatesDrop = true;
            pinView.canShowCallout = false;// 设置是否显示弹出视图
            pinView.draggable = false;// 设置支持拖动
        }
        return pinView;
    }
    if ([annotation isKindOfClass:[ProjectsAnnotation class]]) {
        ProjectsAnnotation *customAnn = (ProjectsAnnotation *)annotation;
        
        PGCAnnotationView *annotationView = (PGCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pointReuseIdentifier"];
        if (!annotationView) {
            annotationView = [[PGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pointReuseIdentifier"];
            annotationView.name = customAnn.name;
            annotationView.desc = customAnn.desc;
            annotationView.annotation = customAnn;
            annotationView.image = [UIImage imageNamed:@"地图定位"];
            annotationView.canShowCallout = true;// 设置是否显示弹出视图
            annotationView.draggable = false;// 设置支持拖动
            
            // 添加导航按钮
            UIButton *navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            navigationButton.bounds = CGRectMake(0, 0, 100, 60);
            navigationButton.backgroundColor = [UIColor grayColor];
            [navigationButton setTitle:@"导航" forState:UIControlStateNormal];
            annotationView.rightCalloutAccessoryView = navigationButton;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation.title isKindOfClass:[NSNull class]]) {
        return;
    }
//    // 起始位置
//    
//    MKPlacemark *currentPlacemark = [[MKPlacemark alloc] initWithCoordinate:mapView.userLocation.coordinate addressDictionary:nil];
//    MKMapItem *currentItem = [[MKMapItem alloc] initWithPlacemark:currentPlacemark];
//    // 目的地
//    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:view.annotation.coordinate addressDictionary:nil];
//    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
//    
//    // 创建导航请求
//    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
//    // 设置起点
//    request.source = currentItem;
//    // 设置终点
//    request.destination = destinationItem;
//    
//    // 创建导航
//    MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
//    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
//        // routes: 路线信息
//        // polyline: 路线
//        // 此处添加的路径并不会呈现在地图上，需要通过对路线渲染显示路线
//        [mapView addOverlay:response.routes[0].polyline];
//    }];
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view
{
    
}


#pragma mark - AMapNaviDriveManagerDelegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showNaviRoutes];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onArrivedDestination");
}


#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@", __func__, [manager class]);
    
    [MBProgressHUD showError:error.localizedDescription toView:self.view];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (!location) {
        [self stopSerialLocation];
        return;
    }
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"(%f, %f)", latitude, longitude);
    
    CurrentAnnotation *current = [[CurrentAnnotation alloc] init];
    current.coordinate = location.coordinate;
    [self.mapView addAnnotation:current];
    [self.annotations addObject:current];
    [self.mapView showAnnotations:self.annotations animated:true];
    
    [self.mapView setCenterCoordinate:location.coordinate animated:true];
    
    [self stopSerialLocation];
}


#pragma mark - Handle Navi Routes

- (void)showNaviRoutes
{
    if ([self.driveManager.naviRoutes count] <= 0)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
    //将路径显示到地图上
    for (NSNumber *aRouteID in [self.driveManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driveManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        [selectablePolyline setRouteID:[aRouteID integerValue]];
        
        [self.mapView addOverlay:selectablePolyline];
        free(coords);
        
        //更新CollectonView的信息
//        RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
//        info.routeID = [aRouteID integerValue];
//        info.title = [NSString stringWithFormat:@"路径ID:%ld | 路径计算策略:%ld", (long)[aRouteID integerValue], (long)[self.preferenceView strategyWithIsMultiple:self.isMultipleRoutePlan]];
//        info.subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
//        
//        [self.routeIndicatorInfoArray addObject:info];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
//    [self.routeIndicatorView reloadData];
    
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}

- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    //在开始导航前进行路径选择
    if ([self.driveManager selectNaviRouteWithRouteID:routeID])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}

- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop) {
         if ([overlay isKindOfClass:[SelectableOverlay class]]) {
             SelectableOverlay *selectableOverlay = (SelectableOverlay *)overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID) {
                 /* 设置选中状态. */
                 selectableOverlay.selected = true;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
             } else {
                 /* 设置选中状态. */
                 selectableOverlay.selected = false;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             [overlayRenderer glRender];
         }
     }];
}


#pragma mark - Private

- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}


- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}



#pragma mark - Action Handlers

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:true];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:true];
}

- (void)gpsAction
{
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];
        [self.gpsButton setSelected:true];
    }
}


#pragma mark - Getter

- (UIView *)zoomPannelView {
    if (!_zoomPannelView) {
        _zoomPannelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
        _zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(_zoomPannelView.bounds) - 10, self.view.bounds.size.height -  CGRectGetMidY(_zoomPannelView.bounds) - 10);
        _zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
        [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
        [incBtn sizeToFit];
        [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
        [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
        [decBtn sizeToFit];
        [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_zoomPannelView addSubview:incBtn];
        [_zoomPannelView addSubview:decBtn];
    }
    return _zoomPannelView;
}

- (UIButton *)gpsButton {
    if (!_gpsButton) {
        _gpsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _gpsButton.center = CGPointMake(CGRectGetMidX(_gpsButton.bounds) + 10, self.view.bounds.size.height -  CGRectGetMidY(_gpsButton.bounds) - 20);
        _gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _gpsButton.backgroundColor = [UIColor whiteColor];
        _gpsButton.layer.cornerRadius = 4;
        [_gpsButton setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
        [_gpsButton addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gpsButton;
}

- (NSMutableArray *)annotations {
    if (!_annotations) {
        _annotations = [NSMutableArray array];
        
        ProjectsAnnotation *pointAnnotation = [[ProjectsAnnotation alloc] init];
        double lat = [_projectInfo.lat doubleValue];
        double lng = [_projectInfo.lng doubleValue];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
        pointAnnotation.name = _projectInfo.name;
        pointAnnotation.desc = _projectInfo.desc;
        pointAnnotation.title = _projectInfo.name;
        pointAnnotation.subtitle = _projectInfo.desc;
        
        [_annotations addObject:pointAnnotation];
    }
    return _annotations;
}


- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.mapType = MAMapTypeStandard;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsScale = true;
        _mapView.scaleOrigin = CGPointMake(10, 74);
        _mapView.showsCompass = true;
        CGFloat width = _mapView.compassSize.width;
        _mapView.compassOrigin = CGPointMake(SCREEN_WIDTH - width - 10, 74);
        _mapView.showsUserLocation = true;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = false;
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        // 定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout = 2;
        // 逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}

- (AMapNaviDriveManager *)driveManager {
    if (!_driveManager) {
        _driveManager = [[AMapNaviDriveManager alloc] init];
        _driveManager.delegate = self;
    }
    return _driveManager;
}


@end
