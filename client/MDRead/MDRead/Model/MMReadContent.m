//
//  MMReadContent.m
//  MDRead
//
//  Created by midoks on 2017/6/3.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadContent.h"
#import "MMReadChapterModel.h"
#import "MMCommon.h"
#import "MMNovelApi.h"

@interface MMReadContent() <NSCoding>

@end


@implementation MMReadContent

-(id)init
{
    self = [super init];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
     _content = [aDecoder decodeObjectForKey:@"content"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_content forKey:@"content"];
}


+(MMReadContent*)shareInstance
{
    static  MMReadContent *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMReadContent alloc] init];
    });
    return shareInstance;
}


#pragma mark - 获取文章内容 -
-(void)getChapterInfo:(MMReadChapterModel *)chapterInfo
          success:(void (^)(id responseObject))success
          failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    
    NSString *book_id = chapterInfo.bid;
    NSString *chapter_id = chapterInfo.cid;
    NSString *source_id = chapterInfo.sid;
    
    NSString *folderName = [NSString stringWithFormat:@"%@_%@", book_id, source_id];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", book_id, chapter_id];

    
    BOOL r = [MMCommon isExistDocsModel:[self getWebSite] folderName:folderName fileName:fileName];
    if (r) {
        MMReadContent *m = [MMCommon docsModelGet:[self getWebSite] folderName:folderName fileName:fileName];
        MDLog(@"cahce chapter content:%@", fileName);
        success(m.content);
    } else {
        [[MMNovelApi shareInstance] BookContent:book_id chapter_id:chapter_id source_id:source_id success:^(id responseObject) {
            MDLog(@"net chapter content:%@", fileName);
            success(responseObject);
            _content = responseObject;
            [MMCommon docsModelSave:[self getWebSite] folderName:folderName fileName:fileName object:self];
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        }];
    }
}

#pragma mark - 获取来源地址 -
-(NSString *)getWebSite
{
    return @"website";
}

@end
