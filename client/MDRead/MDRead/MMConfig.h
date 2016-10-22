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

//配置名
#define MDCONf_IsFristOpened @"IsFristOpened"

//阅读配置
// YES
#define MDCONF_R_MOONDAY     @"rMoonDay"


@interface MMConfig : NSObject

+(void)initConf;

+ (NSString*)getOption:(NSString *)key;
+ (BOOL)getBoolOption:(NSString *)key;

+ (void)setOption:(NSString *)key value:(NSString *)value;
+ (void)setOption:(NSString *)key boolValue:(BOOL)value;

@end
