//
//  PGCAnnotationView.m
//  跑工程
//
//  Created by leco on 2016/11/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCAnnotationView.h"
#import "PGCCalloutView.h"

#define kCalloutWidth   160
#define kCalloutHeight  85

@implementation PGCAnnotationView

@synthesize calloutView;
@synthesize name;
@synthesize desc;

- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    if (self.selected == selected) {
//        return;
//    }
//    if (selected) {
//        [self addSubview:self.calloutView];
//    } else {
//        [self.calloutView removeFromSuperview];
//    }
//    [super setSelected:selected animated:animated];
//}
//
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    BOOL inside = [super pointInside:point withEvent:event];
//    
//    if (!inside && self.selected)  {
//        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
//    }
//    return inside;
//}

- (UIView *)calloutView {
    if (!calloutView) {
        PGCCalloutView *view = [[PGCCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        view.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, -CGRectGetHeight(view.bounds) / 2.f + self.calloutOffset.y);
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = RGB(76, 141, 174);
        titleLabel.font = SetFont(15);
        titleLabel.text = name;
        [view addSubview:titleLabel];
        titleLabel.sd_layout
        .topSpaceToView(view, 5)
        .leftSpaceToView(view, 5)
        .rightSpaceToView(view, 5)
        .heightIs(20);
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.textColor = RGB(102, 102, 102);
        descLabel.font = SetFont(13);
        descLabel.text = desc;
        [view addSubview:descLabel];
        descLabel.sd_layout
        .topSpaceToView(titleLabel, 0)
        .leftSpaceToView(view, 5)
        .rightSpaceToView(view, 5)
        .autoHeightRatio(0)
        .maxHeightIs(50);
        
        calloutView = view;
    }
    return calloutView;
}

@end
