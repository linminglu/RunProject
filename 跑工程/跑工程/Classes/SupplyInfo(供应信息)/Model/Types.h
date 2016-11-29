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
@property (assign, nonatomic) int status;/** 状态  */
@property (copy, nonatomic) NSString *create_time;/** 创建时间 */
@property (copy, nonatomic) NSString *update_time;/** 更新时间 */

@end
