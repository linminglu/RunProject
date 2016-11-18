//
//  Types.h
//  跑工程
//
//  Created by leco on 2016/11/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Types : NSObject

@property (assign, nonatomic) int id;/** id */
@property (assign, nonatomic) int parent_id;/** parent_id */
@property (copy, nonatomic) NSString *name;/** 名称 */
@property (assign, nonatomic) int sequence;/** sequence */

@end
