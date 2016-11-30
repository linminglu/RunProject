//
//  CurrentAnnotation.h
//  跑工程
//
//  Created by leco on 2016/11/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CurrentAnnotation : MAPointAnnotation

@property (copy, nonatomic) NSString *name;/** 当前位置de标题 */
@property (copy, nonatomic) NSString *desc;/** 当前位置的详情 */

@end
