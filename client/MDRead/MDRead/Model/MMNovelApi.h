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

#pragma mark - 书籍信息 -
-(void)BookInfo:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure;

#pragma mark - 书籍章节内容 -
-(void)BookContent:(NSString *)book_id
        chapter_id:(NSString *)chapter_id
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

#pragma mark - 接口标题 -
-(NSString *)getApiTitle;

#pragma mark - 是否存在反馈 -
-(BOOL)isExistFeedBack;

#pragma mark - 意见反馈 -
-(void)feedBack:(NSString *)content
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure;


#pragma mark - 切换来源地址 -
-(void)switchWebSite:(NSString *)url
             success:(void (^)())success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;

#pragma mark - 接口检测 -
-(void)test:(NSString *)url
    success:(void (^)())success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure;

@end
