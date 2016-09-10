//
//  MMCommon.h
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 日志输出
#ifdef DEBUG
#define MDLog(...) NSLog(__VA_ARGS__)
#else
#define MDLog(...)
#endif

#pragma mark 通用宏
#define MDDeviceW ([UIScreen mainScreen].bounds.size.width)
#define MDDeviceH ([UIScreen mainScreen].bounds.size.height)

@interface MMCommon : NSObject


+(void)asynTask:(void (^)())task;
+(UIColor *)randomColor;

+(void)showMessage:(NSString *)message;

+(NSString *)md5:(NSString *)md5Str;
+(NSString *)fileMd5:(NSString *)path;

@end
