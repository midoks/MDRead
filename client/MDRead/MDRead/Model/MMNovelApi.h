//
//  MMNovelApi.h
//  MDRead
//
//  Created by midoks on 16/5/28.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "JSONKit.h"

@interface MMNovelApi : NSObject
{

    AFHTTPSessionManager *_manager;
    NSMutableDictionary *_args;
}

+(MMNovelApi*)shareInstance;

#pragma mark - 设置参数 -
-(void)setArgs:(NSString *)key value:(NSString *)value;
-(void)addArgs:(NSString *)key dic:(NSMutableDictionary *)dic;

#pragma mark - 搜索 -
-(void)Search:(NSString *)word
      success:(void (^)(id   responseObject))success
      failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)BookList:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)BookContent:(NSString *)chapter_id
         source_id:(NSString *)source_id
           success:(void (^)(id responseObject))success
           failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)recommend:(void (^)(id responseObject))success
         failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)rand:(void (^)(id responseObject))success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)BangList:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)AuthorList:(void (^)(id responseObject))success
          failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)downloadFile;

-(void)test:(NSString *)url
    success:(void (^)())success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure;

@end
