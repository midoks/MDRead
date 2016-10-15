//
//  MMCommon.h
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface MMCommon : NSObject


+(void)asynTask:(void (^)())task;
+(UIColor *)randomColor;

+(void)showMessage:(NSString *)message;

+(NSString *)md5:(NSString *)md5Str;
+(NSString *)fileMd5:(NSString *)path;

@end
