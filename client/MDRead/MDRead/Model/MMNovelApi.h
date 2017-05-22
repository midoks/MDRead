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

#pragma mark - 书籍章节列表 -
-(void)BookList:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure;

#pragma mark - 书籍章节内容 -
-(void)BookContent:(NSString *)chapter_id
         source_id:(NSString *)source_id
           success:(void (^)(id responseObject))success
           failure:(void (^)(int ret_code, NSString *ret_msg))failure;

#pragma mark - 书籍热门推荐 -
-(void)recommend:(void (^)(id responseObject))success
         failure:(void (^)(int ret_code, NSString *ret_msg))failure;

#pragma mark - 书籍随机推荐 -
-(void)rand:(void (^)(id responseObject))success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure;

#pragma mark - 数据榜单列表 -
-(void)BangList:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure;


-(void)AuthorList:(void (^)(id responseObject))success
          failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)downloadFile;

-(void)test:(NSString *)url
    success:(void (^)())success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure;

@end
