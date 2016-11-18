//
//  Contacts.h
//  跑工程
//
//  Created by leco on 2016/11/15.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contacts : NSObject

@property (assign, nonatomic) int id;/** id */
@property (assign, nonatomic) int ref_id;/** ref_id */
@property (assign, nonatomic) int type;/** type */
@property (copy, nonatomic) NSString *name;/** 姓名 */
@property (copy, nonatomic) NSString *phone;/** 电话 */
@property (assign, nonatomic) int sequence;/** sequence */

@end
