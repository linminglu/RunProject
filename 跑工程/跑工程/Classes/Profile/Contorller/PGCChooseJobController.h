//
//  PGCChooseJobController.h
//  跑工程
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JobBlock) (NSString *job);

@interface PGCChooseJobController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *parameters;/** 上传参数 */

@property (nonatomic,copy) JobBlock block;

@end
