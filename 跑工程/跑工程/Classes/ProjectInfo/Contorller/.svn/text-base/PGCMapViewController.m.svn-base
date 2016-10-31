//
//  PGCMapViewController.m
//  跑工程
//
//  Created by leco on 2016/10/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCMapViewController.h"
#import <MapKit/MapKit.h>

static NSString *const kAnnotationViewIdentifier = @"AnnotationViewIdentifier";

@interface PGCMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

#pragma mark - Initialize
- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    // 定位
    _locationManager = [[CLLocationManager alloc] init];
    // 请求定位授权
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    // 地图
    [self.view addSubview:self.mapView];
    
    // 长按手势添加大头针
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAddAnnotation:)];
    
    [self.mapView addGestureRecognizer:longPressGesture];
}

#pragma mark - Events
- (void)respondsToSegmentedControl:(UISegmentedControl *)control {
    
    _mapView.mapType = control.selectedSegmentIndex;
}

- (void)respondsToAddAnnotation:(UILongPressGestureRecognizer *)gesture {
    PGCLog(@"%@", NSStringFromSelector(_cmd));
    
    // 在手势开始的时候创建一个标注数据源
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 获取手势在地图上的位置
        CGPoint location = [gesture locationInView:_mapView];
        // 将手势位置转换成经纬度
        CLLocationCoordinate2D coordinate = [_mapView convertPoint:location toCoordinateFromView:_mapView];
        // 创建标注数据源，MKPointAnnotation为系统提供的标注数据源，如果想要自定义，必须遵守<MKAnnotation>协议
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        // 设置标注数据源的经纬度
        annotation.coordinate = coordinate;
        annotation.title = @"Hi, girl!";
        annotation.subtitle = @"I'm here! Call me:123456789";
        
        // 添加标注
        [_mapView addAnnotation:annotation];
    }
}

#pragma mark - MKMapViewDelegate
// 地图加载失败
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    PGCLog(@"%@", error.localizedDescription);
}

// 自定义标注视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationViewIdentifier];
    
    if (!pinAnnotationView) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationViewIdentifier];
    }
    
    // 更新标注数据源，重用机制有可能导致标注数据源是从缓存池里面获取的
    pinAnnotationView.annotation = annotation;
    // 设置大头针颜色
    pinAnnotationView.pinTintColor = [UIColor orangeColor];
    // 设置凋零效果
    pinAnnotationView.animatesDrop = true;
    // 设置是否显示弹出视图
    pinAnnotationView.canShowCallout = true;
    
    // pinAnnotationView.image = custom image;
    
    // 调整弹框偏移
    pinAnnotationView.calloutOffset = CGPointMake(0, -10);
    
    // 添加导航按钮
    UIButton *navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationButton.bounds = CGRectMake(0, 0, 100, 60);
    navigationButton.backgroundColor = [UIColor grayColor];
    [navigationButton setTitle:@"导航" forState:UIControlStateNormal];
    
    pinAnnotationView.rightCalloutAccessoryView = navigationButton;
    
    // pinAnnotationView.detailCalloutAccessoryView 可高度定制标注视图详情视图
    
    return pinAnnotationView;
}

// 如果自定义的calloutAccessoryView继承于UIControl，那么在该空间与用户交互的时候，此方法会被直接调用
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation.title isKindOfClass:[NSNull class]]) {
        return;
    }
    
    // 起始位置
    MKPlacemark *currentPlacemark = [[MKPlacemark alloc] initWithCoordinate:mapView.userLocation.coordinate addressDictionary:nil];
    MKMapItem *currentItem = [[MKMapItem alloc] initWithPlacemark:currentPlacemark];
    // 目的地
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:view.annotation.coordinate addressDictionary:nil];
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    // 创建导航请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 设置起点
    request.source = currentItem;
    // 设置终点
    request.destination = destinationItem;
    
    // 创建导航
    MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        // routes: 路线信息
        // polyline: 路线
        // 此处添加的路径并不会呈现在地图上，需要通过对路线渲染显示路线
        [mapView addOverlay:response.routes[0].polyline];
    }];
}

// 渲染路径
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    // 构造渲染器
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 2.0f;
    renderer.strokeColor = [UIColor redColor];
    
    return renderer;
}

// 选中某个标注视图
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // 1.获取经纬度
    CLLocationCoordinate2D coordinate = view.annotation.coordinate;
    // 2.根据经纬度创建一个CLLocation
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    // 3.逆地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            // 编码失败
            PGCLog(@"error:%@", error.localizedDescription);
        } else {
            // placemark 包含了经纬度所在的地理位置信息(城市编码、街道名称、区...)
            CLPlacemark *placemark = placemarks.firstObject;
            PGCLog(@"%@", placemark);
        }
        
    }];
}

#pragma mark - CLLocationManagerDelegate
// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    PGCLog(@"error:%@", error.localizedDescription);
}

// 位置更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 获取最新的定位信息
//    CLLocation *location = locations.lastObject;
//    CLLocationDegrees longitude = location.coordinate.longitude;
//    CLLocationDegrees latitude = location.coordinate.latitude;
//    CLLocationDegrees altitude = location.altitude;
    
    // 结束定位
    [_locationManager stopUpdatingLocation];
}

#pragma mark - Getters
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        // 设置跟随模式
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        // 设置地图样式
        _mapView.mapType = MKMapTypeStandard;
        // 设置用户地理位置标题
        _mapView.userLocation.title = @"";
        _mapView.userLocation.subtitle = @"";
        
        // iOS9
        _mapView.showsScale = true; // 显示比例尺
        _mapView.showsCompass = true; // 显示指南针
        _mapView.showsTraffic = true; // 显示交通
        
        // 设置代理
        _mapView.delegate = self;
    }
    return _mapView;
}

@end
