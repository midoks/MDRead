//
//  MMReadModel.m
//  MDRead
//
//  Created by midoks on 2017/5/27.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadModel.h"
#import "MMCommon.h"
#import "MMNovelApi.h"
#import "MMReadChapterListModel.h"

@interface MMReadModel() <NSCoding>

@property (nonatomic, strong) MMReadChapterListModel *chapterList;

@end

@implementation MMReadModel

-(id)init
{
    if(self = [super init]){
    
    }
    return self;
}


#pragma mark - NSCoding -
-(void)encodeWithCoder:(NSCoder *)aCoder
{

    MDLog(@"%@", @"类型保存。。");
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        MDLog(@"12123123123123123123");
    }
    return self;
}

#pragma mark - 获取来源地址 -
-(NSString *)getWebSite
{
    return @"website";
}


+(MMReadModel*)shareInstance
{
    static  MMReadModel *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMReadModel alloc] init];
    });
    return shareInstance;
}

#pragma mark - 解析book列表数据 -
-(void)parseBookList:(NSString *)book_id
           source_id:(NSString *)source_id
             success:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    
    
    //获取书籍章节列表
    [[MMNovelApi shareInstance] BookList:book_id source_id:source_id success:^(id responseObject) {
        
        MDLog(@"%@", responseObject);
        NSMutableArray *list = [responseObject objectForKey:@"data"];
        
        //MDLog(@"%@", list);
        
        success(list);
    } failure:^(int ret_code, NSString *ret_msg) {
        failure(ret_code, ret_msg);
    }];
}

#pragma mark - 解析book数据 -
-(void)parseBookContent:(NSString *)book_id
              source_id:(NSString *)source_id
                success:(void (^)(id responseObject))success
                failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    [self parseBookList:book_id source_id:source_id success:^(id responseObject) {
        MDLog(@"responseObject:%@", responseObject);
        
        NSMutableDictionary *chapter = [responseObject objectAtIndex:0];
        
        MDLog(@"%@", chapter);
        
        NSString *book_id = [chapter objectForKey:@"bid"];
        NSString *chapter_id = [chapter objectForKey:@"cid"];
        NSString *source_id = [chapter objectForKey:@"sid"];
        
        [[MMNovelApi shareInstance] BookContent:book_id chapter_id:chapter_id source_id:source_id success:^(id responseObject) {
            
            MDLog(@"%@", responseObject);
            
            success(responseObject);
            
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        }];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        failure(ret_code, ret_msg);
    }];
}


#pragma mark - 返回阅读模型 -
-(MMReadModel *)readModel
{
    MMReadModel *model;
    if([self isExistFileBook]){
        MDLog(@"%@", @"存在文档");
        id m = [self readFileBook];
        
        model = (MMReadModel *)m;
        NSLog(@"%@", m);
    } else {
        MDLog(@"%@", @"不存在文档");
        
        [self save];
    }
    
    return model;
}


#pragma mark 读取文件
-(id)readFileBook
{
    id model = [MMCommon docsModelGet:[self getWebSite] folderName:@"ss" fileName:@"ss"];
    return model;
}

#pragma mark - 保存文档 -
-(void)save
{
    [MMCommon docsModelSave:[self getWebSite] folderName:@"ss" fileName:@"ss" object:self];
}

#pragma mark - 是否存在文件数据 -
-(BOOL)isExistFileBook
{
    
    BOOL r = [MMCommon isExistDocsModel:[self getWebSite] folderName:@"ss" fileName:@"ss"];
    if (r) {
        return TRUE;
    }
    return FALSE;
}

@end
