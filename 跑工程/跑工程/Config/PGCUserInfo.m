//
//  PGCUserInfo.m
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCUserInfo.h"

@implementation PGCUserInfo

- (instancetype)initWithDic:(NSDictionary *)dic
{//赋值
    [self setValuesForKeysWithDictionary:dic];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{//防崩
    
}

+ (void)clearUserInfo
{
    [PGCUserDefault setObject:@{} forKey:@"AccountData"];
    [PGCUserDefault synchronize];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@""];
    NSFileManager *manger = [NSFileManager defaultManager];
    [manger removeItemAtPath:fullPath error:nil];
}

+ (void)reLogin
{
    [PGCUserDefault objectForKey:@"account"];
    [PGCUserDefault objectForKey:@"password"];
}

+ (void)refreshUserMessageWithKey:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *dic = [PGCUserDefault objectForKey:@"AccountData"];
    NSArray *arr = [dic allKeys];//获取所有的key
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *temp in arr) {
        
        [newDic setObject:dic[temp] forKey:temp];
        
        if ([temp isEqualToString:key]) {
            
            [newDic setObject:value forKey:temp];
        }
    }
    NSDictionary *dicc  = [NSDictionary dictionaryWithDictionary:newDic];
    
    [PGCUserDefault setObject:dicc forKey:@"AccountData"];
    [PGCUserDefault synchronize];
}

@end
