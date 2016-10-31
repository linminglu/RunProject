//
//  GCDHelper.h
//  laboratoryB305
//
//  Created by xiaorizi on 16/1/28.
//  Copyright © 2016年 snail_hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDHelper : NSObject

typedef void(^BlockCode)();

#pragma mark- 异步
/**
 *  异步多线程,主要还是由主线程的子线程来进行执行,一般用于ui绘制
 *
 *  @param runCode 异步执行的代码块
 */
+ (void)asyncGCDMainQueue:(void(^)())runCode;

/**
 *  异步多线程，用于执行那些比较麻烦的事情，参数代表了线程执行的优先级，0代表默认优先级
 *
 *  @param prioity 线程优先级
 *  @param runCode 异步执行代码块
 */
+ (void)asyncGCDGlobalQueuePrioity:(int)prioity runBlock:(void(^)())runCode;

/**
 *  开启一组异步线程，进行执行任务，将需要执行的代码段放入arr中 会自动将其变成任务进行执行 最后通过全部执行完成的回调进行任务结束
 *
 *  @param blockArr    装有执行任务的代码块
 *  @param prioity     优先级
 *  @param finishBlock 全部执行完成之后的代码块
 */
+ (void)asyncGCDGroup:(NSArray *)blockArr prioity:(int)prioity finishBlock:(void(^)())finishBlock;

#pragma mark- 同步
/**
 *  同步线程，按顺序执行
 *
 *  @param prioity 优先级
 *  @param runCode 执行的任务代码块
 */
+ (void)syncGCDMainQueuePrioity:(int)prioity runBlock:(void(^)())runCode;

#pragma mark- 延时
/**
 *  延时执行的线程
 *
 *  @param runCode 执行的任务代码块
 *  @param dely    延时时间
 */
+ (void)afterGCD:(void(^)())runCode dely:(int)dely;

#pragma mark- 重复执行
/**
 *  重复执行的线程
 *
 *  @param prioity    优先级
 *  @param applyCount 重复次数
 *  @param runCode    执行的任务代码块
 */
+ (void)applyGCDQueuePrioity:(int)prioity applyCount:(int)applyCount runCode:(void(^)(size_t i))runCode;

@end
