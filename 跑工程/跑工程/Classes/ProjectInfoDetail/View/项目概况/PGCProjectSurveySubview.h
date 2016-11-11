//
//  PGCProjectSurveySubview.h
//  跑工程
//
//  Created by leco on 2016/11/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LabelHeight 30

@interface PGCProjectSurveySubview : UIView

- (void)addBtnTarget:(id)target action:(SEL)action;
- (void)loadDataWithModel:(id)model;

@end
