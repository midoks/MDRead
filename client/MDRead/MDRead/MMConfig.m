//
//  MMConfig.m
//  MDRead
//
//  Created by midoks on 2016/10/21.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMConfig.h"


@implementation MMConfig

+(void)initConf
{
    if(![self getBoolOption:MDCONF_INIT]){
        [self setOption:MD_VERSION value:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        [self setOption:MDCONF_R_MOONDAY boolValue:YES];
        
        [self setOption:MDCONF_INIT boolValue:YES];
    }
}

#pragma mark - 获取值 -
+ (NSString*)getOption:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)getBoolOption:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

#pragma mark - 设置参数 -
+ (void)setOption:(NSString *)key value:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+ (void)setOption:(NSString *)key boolValue:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}


@end
