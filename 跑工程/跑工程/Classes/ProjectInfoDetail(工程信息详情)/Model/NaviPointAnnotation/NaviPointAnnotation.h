//
//  NaviPointAnnotation.h
//  跑工程
//
//  Created by leco on 2016/12/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

typedef NS_ENUM(NSInteger, NaviPointAnnotationType)
{
    NaviPointAnnotationStart,
    NaviPointAnnotationWay,
    NaviPointAnnotationEnd
};


@interface NaviPointAnnotation : MAPointAnnotation

@property (nonatomic, assign) NaviPointAnnotationType navPointType;

@end
