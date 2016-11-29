//
//  PGCProjectSurveyScrollView.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCProject;

static NSString *const kProjectSurveyScrollView = @"PGCProjectSurveyScrollView";

@interface PGCProjectSurveyScrollView : UICollectionViewCell

@property (strong, nonatomic) PGCProject *project;

@end
