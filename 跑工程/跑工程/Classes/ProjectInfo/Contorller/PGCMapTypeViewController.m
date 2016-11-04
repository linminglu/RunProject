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
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface PGCMapTypeViewController () <MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate>

@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapLocationManager *locationManager;

- (void)initializeUserInterface; /** 初始化用户界面 */

@end

@implementation PGCMapTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    
    // 长按手势添加大头针
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAddAnnotation:)];    
    [self.mapView addGestureRecognizer:longPressGesture];
    
    [self configLocationManager];
    [self startSerialLocation];
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        NSLog(@"location:%@", location);
        
        if (regeocode) {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}


#pragma mark - Events

- (void)respondsToAddAnnotation:(UILongPressGestureRecognizer *)gesture {
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


- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    self.locationManager.pausesLocationUpdatesAutomatically = false;
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    // 定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 2;
    // 逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    MAPinAnnotationView *pinAnnotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    
    if (!pinAnnotationView) {
        pinAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    
    // 更新标注数据源，重用机制有可能导致标注数据源是从缓存池里面获取的
    pinAnnotationView.annotation = annotation;
    // 设置大头针颜色
    pinAnnotationView.pinColor = MAPinAnnotationColorGreen;
    // 设置凋零效果
    pinAnnotationView.animatesDrop = true;
    // 设置是否显示弹出视图
    pinAnnotationView.canShowCallout = true;
    // 调整弹框偏移
    pinAnnotationView.calloutOffset = CGPointMake(0, -10);
    
    // 添加导航按钮
    UIButton *navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationButton.bounds = CGRectMake(0, 0, 100, 60);
    navigationButton.backgroundColor = [UIColor grayColor];
    [navigationButton setTitle:@"导航" forState:UIControlStateNormal];
    
    pinAnnotationView.rightCalloutAccessoryView = navigationButton;
    
    return pinAnnotationView;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation.title isKindOfClass:[NSNull class]]) {
        return;
    }

}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
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


#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    [self stopSerialLocation];
}


- (void)startSerialLocation {
    //开始定位
    [self.locationManager startUpdatingLocation];
}


- (void)stopSerialLocation {
    //停止定位
    [self.locationManager stopUpdatingLocation];
}



@end
