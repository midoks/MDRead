//
//  MMSystemInfo.m
//  MDRead
//
//  Created by midoks on 16/8/4.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSystemInfo.h"


@interface MMSystemInfo()

@property (nonatomic, strong) NSMutableDictionary *args;

@end

@implementation MMSystemInfo

+(MMSystemInfo*)shareInstance
{
    static  MMSystemInfo *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMSystemInfo alloc] init];
    });
    return shareInstance;
}

-(NSMutableDictionary *) getInfo
{
    _args = [[NSMutableDictionary alloc] init];
    
    [_args setValue:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:@"app_uuid"];
    [_args setValue:[[UIDevice currentDevice] name] forKey:@"app_name"];
    [_args setValue:[[UIDevice currentDevice] systemName] forKey:@"app_sysname"];
    [_args setValue:[[UIDevice currentDevice] systemVersion] forKey:@"app_sysverion"];
    [_args setValue:[[UIDevice currentDevice] model] forKey:@"app_model"];
    [_args setValue:[[UIDevice currentDevice] localizedModel] forKey:@"app_localizedmodel"];
    
    return _args;
}

@end
