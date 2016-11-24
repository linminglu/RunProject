//
//  PGCFeedback.h
//  跑工程
//
//  Created by leco on 2016/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCFeedback : NSObject

@property (copy, nonatomic) NSString *content;/** 反馈内容 */
@property (copy, nonatomic) NSString *phone;/** 用户联系电话 */
@property (copy, nonatomic) NSString *name;/** 用户昵称 */

@end
