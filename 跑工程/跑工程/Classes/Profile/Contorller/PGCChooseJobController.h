//
//  PGCChooseJobController.h
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCChooseJobController : UIViewController

typedef void (^JobBlock) (NSString *job);

@property (nonatomic,copy) JobBlock block;

@end
