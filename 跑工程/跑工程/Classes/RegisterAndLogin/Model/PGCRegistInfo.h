//
//  PGCRegistInfo.h
//  跑工程
//
//  Created by leco on 2016/11/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 注册用户的模型
@interface PGCRegistInfo : NSObject

@property (copy, nonatomic) NSString *phone;        /** 电话 */
@property (copy, nonatomic) NSString *verify_code;  /** 验证码 */
@property (copy, nonatomic) NSString *password;     /** 密码 */
@property (copy, nonatomic) NSString *password2;    /** 确认密码 */
@property (copy, nonatomic) NSString *name;         /** 姓名 */
@property (copy, nonatomic) NSString *company;      /** 公司 */

@end
