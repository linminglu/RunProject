//
//  PGCAnnotationView.h
//  跑工程
//
//  Created by leco on 2016/11/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface PGCAnnotationView : MAAnnotationView

@property (copy, nonatomic) NSString *name;/** name */
@property (copy, nonatomic) NSString *desc;/** desc */
@property (strong, nonatomic) UIView *calloutView;

@end
