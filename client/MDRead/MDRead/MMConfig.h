//
//  MMConfig.h
//  MDRead
//
//  Created by midoks on 2016/10/21.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MD_VERSION           @"MD_VERSION"
#define MDCONF_INIT          @"md_init2"

/**
 * 是否第一次使用
 */
#define MDCONf_IsFristOpened @"IsFristOpened"

/**
 * 阅读配置
 * YES:傍晚
 * NO: 白天
 */
#define MDCONF_R_MOONDAY     @"rMoonDay"


@interface MMConfig : NSObject

+(void)initConf;

+ (NSString*)getOption:(NSString *)key;
+ (BOOL)getBoolOption:(NSString *)key;

+ (void)setOption:(NSString *)key value:(NSString *)value;
+ (void)setOption:(NSString *)key boolValue:(BOOL)value;

@end
