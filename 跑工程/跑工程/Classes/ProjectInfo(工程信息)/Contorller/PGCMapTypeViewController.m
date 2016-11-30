//
//  PGCMapTypeViewController.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCMapTypeViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface PGCMapTypeViewController () <MAMapViewDelegate, AMapLocationManagerDelegate>

@property (strong, nonatomic) MAMapView *mapView;/** 地图视图 */
@property (strong, nonatomic) AMapLocationManager *locationManager;/** 定位管理 */
@property (strong, nonatomic) MAPointAnnotation *pointAnn;/** 标注点 */

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
    
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    
    [self startSerialLocation];
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        
        if (regeocode) {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}


#pragma mark - Events

- (void)respondsToAddAnnotation:(UILongPressGestureRecognizer *)gesture
{
    // 在手势开始的时候创建一个标注数据源
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 获取手势在地图上的位置
        CGPoint location = [gesture locationInView:_mapView];
        // 将手势位置转换成经纬度
        CLLocationCoordinate2D coordinate = [_mapView convertPoint:location toCoordinateFromView:_mapView];
        // 创建标注数据源，MKPointAnnotation为系统提供的标注数据源，如果想要自定义，必须遵守<MKAnnotation>协议
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        // 设置标注数据源的经纬度
        annotation.coordinate = coordinate;
        annotation.title = @"Hi, girl!";
        annotation.subtitle = @"I'm here! Call me:123456789";
        
        // 添加标注
        [_mapView addAnnotation:annotation];
    }
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";

        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];

        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            annotationView.canShowCallout = true;// 设置是否显示弹出视图
            annotationView.animatesDrop = true;// 设置凋零效果
            annotationView.draggable = false;// 设置支持拖动
            annotationView.pinColor = MAPinAnnotationColorRed;// 设置大头针颜色
            annotationView.calloutOffset = CGPointMake(0, -10);// 调整弹框偏移

            // 添加导航按钮
//            UIButton *navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            navigationButton.bounds = CGRectMake(0, 0, 100, 60);
//            navigationButton.backgroundColor = [UIColor grayColor];
//            [navigationButton setTitle:@"导航" forState:UIControlStateNormal];
//
//            annotationView.rightCalloutAccessoryView = navigationButton;
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
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    // 1.获取经纬度
    CLLocationCoordinate2D coordinate = view.annotation.coordinate;
    // 2.根据经纬度创建一个CLLocation
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    // 3.逆地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            // 编码失败
            NSLog(@"error:%@", error.localizedDescription);
        } else {
            // placemark 包含了经纬度所在的地理位置信息(城市编码、街道名称、区...)
            CLPlacemark *placemark = placemarks.firstObject;
            NSLog(@"%@", placemark);
        }
    }];
}


#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@", __func__, [manager class]);
    
    [MBProgressHUD showError:error.localizedDescription toView:self.view];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    CLLocationDegrees longitude = location.coordinate.longitude;// 经度
    CLLocationDegrees latitude = location.coordinate.latitude;// 维度
    NSLog(@"location:{lat:%f; lon:%f}", latitude, longitude);
    
    self.pointAnn.coordinate = location.coordinate;
    [self.mapView addAnnotation:self.pointAnn];
    [self.mapView showAnnotations:@[self.pointAnn] animated:true];
    
    [self stopSerialLocation];
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


#pragma mark - Getter

- (MAMapView *)mapView {
    if (!_mapView) {
        // 初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.mapType = MAMapTypeStandard;
        _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
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

- (MAPointAnnotation *)pointAnn {
    if (!_pointAnn) {
        _pointAnn = [[MAPointAnnotation alloc] init];
        _pointAnn.lockedToScreen = false;
        _pointAnn.lockedScreenPoint = self.view.center;
    }
    return _pointAnn;
}

@end
