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
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _chapterList = [aDecoder decodeObjectForKey:@"chapterList"];
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
-(void)parseBookList:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    NSString *book_id = [_bookInfo objectForKey:@"bid"];
    NSString *source_id = [_bookInfo objectForKey:@"sid"];
    
    if ([self isExistFileBook]){
        MMReadModel *p = [self readBook];
        _chapterList = p.chapterList;
        success(_chapterList);
    } else {
        //获取书籍章节列表
        [[MMNovelApi shareInstance] BookList:book_id source_id:source_id success:^(id responseObject) {
            
            NSMutableArray *list = [responseObject objectForKey:@"data"];
            _chapterList = [[NSMutableArray alloc] init];
            
            for (int i=0; i< [list count]; i++) {
                MMReadChapterModel *a = [[MMReadChapterModel alloc] init];
                a.cid = [[list objectAtIndex:i] objectForKey:@"cid"];
                a.sid = [[list objectAtIndex:i] objectForKey:@"sid"];
                a.bid = [[list objectAtIndex:i] objectForKey:@"bid"];
                a.name = [[list objectAtIndex:i] objectForKey:@"name"];
                
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
-(void)parseBookContent:(void (^)(id responseObject))success
                failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    [self parseBookList:^(id responseObject) {

        if ([responseObject count] < 1) {
            failure(-1, @"缺少章节数据!");
            return;
        }
        
        MMReadChapterModel *chapter = [responseObject objectAtIndex:0];
        
        NSString *book_id = chapter.bid;
        NSString *chapter_id = chapter.cid;
        NSString *source_id = chapter.sid;
        
        [[MMNovelApi shareInstance] BookContent:book_id chapter_id:chapter_id source_id:source_id success:^(id responseObject) {
            
            success(responseObject);
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        }];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        failure(ret_code, ret_msg);
    }];
}

#pragma mark 读取文件
-(id)readBook
{
    NSString *folderName = [NSString stringWithFormat:@"%@_%@",[_bookInfo objectForKey:@"bid"], [_bookInfo objectForKey:@"sid"]];
    id model = [MMCommon docsModelGet:[self getWebSite] folderName:folderName fileName:[_bookInfo objectForKey:@"name"]];
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
