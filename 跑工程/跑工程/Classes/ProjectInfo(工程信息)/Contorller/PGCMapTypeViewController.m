//
//  PGCMapTypeViewController.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCMapTypeViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "PGCProject.h"
#import "PGCProjectDetailViewController.h"
#import "PGCAnnotationView.h"
#import "ProjectsAnnotation.h"
#import "CurrentAnnotation.h"

@interface PGCMapTypeViewController () <MAMapViewDelegate, AMapLocationManagerDelegate>

@property (strong, nonatomic) MAMapView *mapView;/** 地图视图 */
@property (strong, nonatomic) UIButton *gpsButton;/** GPS定位按钮 */
@property (strong, nonatomic) UIView *zoomPannelView;/** 比例缩放 */
@property (strong, nonatomic) AMapLocationManager *locationManager;/** 定位管理 */
@property (strong, nonatomic) NSMutableArray *annotations;/** 项目标注数组 */

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCMapTypeViewController

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
    if ([annotation isKindOfClass:[ProjectsAnnotation class]]) {
        ProjectsAnnotation *customAnn = (ProjectsAnnotation *)annotation;
        
        PGCAnnotationView *annotationView = (PGCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pointReuseIdentifier"];
        if (!annotationView) {
            annotationView = [[PGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pointReuseIdentifier"];
            annotationView.name = customAnn.title;
            annotationView.desc = customAnn.subtitle;
            annotationView.annotation = customAnn;
            annotationView.canShowCallout = true;// 设置是否显示弹出视图
            annotationView.draggable = false;// 设置支持拖动
        }
        return annotationView;
    }
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
    return nil;
}


- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[PGCAnnotationView class]]) {
        
        [self.annotations enumerateObjectsUsingBlock:^(MAPointAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ((obj.coordinate.latitude == view.annotation.coordinate.latitude) &&
                (obj.coordinate.longitude == view.annotation.coordinate.longitude)) {
                
                PGCProject *project = self.projectsMap[idx];
                PGCProjectDetailViewController *detailVC = [[PGCProjectDetailViewController alloc] init];
                detailVC.projectDetail = project;
                [self.navigationController pushViewController:detailVC animated:true];
                *stop = true;
            }
        }];
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[PGCAnnotationView class]]) {
        PGCAnnotationView *cusView = (PGCAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
        
        if (!CGRectContainsRect(self.mapView.frame, frame)) {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:true];
        }
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[PGCAnnotationView class]]) {
        
    }
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


#pragma mark - Private

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

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

- (NSMutableArray *)annotations {
    if (!_annotations) {
        _annotations = [NSMutableArray array];
        
        for (PGCProject *model in _projectsMap) {
            ProjectsAnnotation *pointAnnotation = [[ProjectsAnnotation alloc] init];
            double lat = [model.lat doubleValue];
            double lng = [model.lng doubleValue];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
            pointAnnotation.name = model.name;
            pointAnnotation.desc = model.desc;
            pointAnnotation.title = model.name;
            pointAnnotation.subtitle = model.desc;
            [_annotations addObject:pointAnnotation];
        }
    }
    return _annotations;
}

@end
