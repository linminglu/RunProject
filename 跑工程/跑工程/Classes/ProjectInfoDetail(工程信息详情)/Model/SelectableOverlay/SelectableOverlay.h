//
//  SelectableOverlay.h
//  跑工程
//
//  Created by leco on 2016/11/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface SelectableOverlay : NSObject <MAOverlay>

@property (nonatomic, assign) NSInteger routeID;

@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIColor * regularColor;

@property (nonatomic, strong) id<MAOverlay> overlay;

- (instancetype)initWithOverlay:(id<MAOverlay>) overlay;

@end
