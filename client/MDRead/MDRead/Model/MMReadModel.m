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
#import "MMReadChapterModel.h"
#import "MMReadContent.h"

@interface MMReadModel() <NSCoding>

@end

@implementation MMReadModel

-(id)init
{
    self = [super init];
    return self;
}

#pragma mark - NSCoding -
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_chapterList forKey:@"chapterList"];
    [aCoder encodeObject:_record forKey:@"record"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _chapterList = [aDecoder decodeObjectForKey:@"chapterList"];
    _record = [aDecoder decodeObjectForKey:@"record"];
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

-(void)setBookInfo:(NSDictionary *)bookInfo
{
    _bookInfo = bookInfo;
    
    if ([self isExistFileBook]){
        MMReadModel *m = [self readBook];
        _record = m.record;
    }
    
    
    
    
    if (!_record) {
        _record = [[MMReadRecordModel alloc] init];
        _record.chapter_pos = 0;
        _record.chapter_page_pos = 1;
    }
    
    
}

#pragma mark - 解析book列表数据 -
-(void)getBookList:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    NSString *book_id = [_bookInfo objectForKey:@"bid"];
    NSString *source_id = [_bookInfo objectForKey:@"sid"];
    _chapterList = [[NSMutableArray alloc] init];
    
    if ([self isExistFileBook]){
        MMReadModel *m = [self readBook];
        _chapterList = m.chapterList;
        success(m.chapterList);
    } else {
        
        //获取书籍章节列表
        [[MMNovelApi shareInstance] BookList:book_id source_id:source_id success:^(id responseObject) {
            
            NSMutableArray *list = [responseObject objectForKey:@"data"];
            
            for (int i=0; i< [list count]; i++) {
                MMReadChapterModel *a = [[MMReadChapterModel alloc] init];
                a.cid = [[list objectAtIndex:i] objectForKey:@"cid"];
                a.sid = [[list objectAtIndex:i] objectForKey:@"sid"];
                a.bid = [[list objectAtIndex:i] objectForKey:@"bid"];
                a.name = [[list objectAtIndex:i] objectForKey:@"name"];
                a.cache = @"no";
                [_chapterList addObject:a];
            }
            
            [self save];
            success(_chapterList);
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        }];
    }
}

#pragma mark - 解析book数据 -
-(void)getBookContent:(void (^)(id responseObject))success
                failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    
    MDLog(@"getBookContent:_record:%@", _record);
    
    [self goBookChapter:_record.chapter_pos page:_record.chapter_page_pos success:^(id responseObject) {
        success(responseObject);
        
    } failure:^(int ret_code, NSString *ret_msg) {
        failure(ret_code, ret_msg);
    }];
}

-(void)goBookChapter:(NSUInteger)chapter_pos
                page:(NSUInteger)page_pos
             success:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self getBookList:^(id responseObject) {
        
        if ([responseObject count] < 1) {
            failure(-1, @"缺少章节数据!");
            return;
        }
        
        MMReadChapterModel *chapter = [responseObject objectAtIndex:chapter_pos];
        [[MMReadContent shareInstance] getChapterInfo:chapter success:^(id responseObject) {
            
            success(responseObject);
            [[_chapterList objectAtIndex:chapter_pos] setCache:@"yes"];
            [self save];
            
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        }];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        failure(ret_code, ret_msg);
    }];
}


#pragma mark 读取文件
-(MMReadModel*)readBook
{
    NSString *folderName = [NSString stringWithFormat:@"%@_%@",[_bookInfo objectForKey:@"bid"], [_bookInfo objectForKey:@"sid"]];
    MMReadModel *model = [MMCommon docsModelGet:[self getWebSite] folderName:folderName fileName:[_bookInfo objectForKey:@"name"]];
    return model;
}

#pragma mark - 保存文档 -
-(void)save
{
    NSString *folderName = [NSString stringWithFormat:@"%@_%@",[_bookInfo objectForKey:@"bid"], [_bookInfo objectForKey:@"sid"]];
    [MMCommon docsModelSave:[self getWebSite] folderName:folderName fileName:[_bookInfo objectForKey:@"name"] object:self];
}

#pragma mark - 是否存在文件数据 -
-(BOOL)isExistFileBook
{
    NSString *folderName = [NSString stringWithFormat:@"%@_%@",[_bookInfo objectForKey:@"bid"], [_bookInfo objectForKey:@"sid"]];
    BOOL r = [MMCommon isExistDocsModel:[self getWebSite] folderName:folderName fileName:[_bookInfo objectForKey:@"name"]];
    if (r) {
        return TRUE;
    }
    return FALSE;
}

@end
