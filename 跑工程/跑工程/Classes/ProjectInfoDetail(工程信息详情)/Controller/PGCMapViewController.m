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
#import "NaviPointAnnotation.h"
#import "GPSNaviViewController.h"

@interface PGCMapViewController () <MAMapViewDelegate, AMapLocationManagerDelegate>

@property (strong, nonatomic) MAMapView *mapView;/** 地图视图 */
@property (strong, nonatomic) UIButton *gpsButton;/** GPS定位按钮 */
@property (strong, nonatomic) UIView *zoomPannelView;/** 比例缩放 */
@property (strong, nonatomic) NSMutableArray *annotations;/** 项目标注数组 */
@property (strong, nonatomic) AMapLocationManager *locationManager;/** 定位管理 */
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
    GPSNaviViewController *naviVC = [[GPSNaviViewController alloc] init];
    naviVC.startPoint = self.startPoint;
    naviVC.endPoint = self.endPoint;
    [self.navigationController pushViewController:naviVC animated:true];
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
    
    // 设置起始点
    self.startPoint = [AMapNaviPoint locationWithLatitude:latitude longitude:longitude];
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起始点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;
    
    // 设置当前位置的标注数据
    CurrentAnnotation *current = [[CurrentAnnotation alloc] init];
    current.coordinate = location.coordinate;
    [self.mapView addAnnotation:current];
    [self.annotations addObject:current];
    
    // 在地图上显示标注视图
    [self.mapView showAnnotations:self.annotations animated:true];
    [self.mapView setCenterCoordinate:location.coordinate animated:true];
    
    [self stopSerialLocation];
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
        
        self.endPoint = [AMapNaviPoint locationWithLatitude:lat longitude:lng];
        NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
        [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
        endAnnotation.title = @"终点";
        endAnnotation.navPointType = NaviPointAnnotationEnd;
        
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
        _locationManager.allowsBackgroundLocationUpdates = true;
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


@end
