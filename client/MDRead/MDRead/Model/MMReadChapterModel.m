//
//  MMReadChapterListModel.m
//  MDRead
//
//  Created by midoks on 2017/5/29.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadChapterModel.h"
#import "MMCommon.h"

@interface MMReadChapterModel() <NSCoding>


@end

@implementation MMReadChapterModel

-(id)init
{
    self = [super init];

    return self;
}


+(MMReadChapterModel*)shareInstance
{
    static  MMReadChapterModel *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMReadChapterModel alloc] init];
    });
    return shareInstance;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    _bid = [aDecoder decodeObjectForKey:@"bid"];
    _cid = [aDecoder decodeObjectForKey:@"cid"];
    _sid = [aDecoder decodeObjectForKey:@"sid"];
    _name = [aDecoder decodeObjectForKey:@"name"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_bid forKey:@"bid"];
    [aCoder encodeObject:_cid forKey:@"cid"];
    [aCoder encodeObject:_sid forKey:@"sid"];
    [aCoder encodeObject:_name forKey:@"name"];
}

#pragma mark - 获取来源地址 -
-(NSString *)getWebSite
{
    return @"website";
}

#pragma mark - 保存文档 -
-(void)save
{
//    NSString *folderName = [NSString stringWithFormat:@"%@_%@", _bid, _sid];
//    NSString *fileName = [NSString stringWithFormat:@"%@", _cid];
//    [MMCommon docsModelSave:[self getWebSite] folderName:folderName fileName:fileName object:self];
}

#pragma mark - 是否存在文件数据 -
-(BOOL)isExistFileBook
{
    NSString *folderName = [NSString stringWithFormat:@"%@_%@", _bid, _sid];
    NSString *fileName = [NSString stringWithFormat:@"%@", _cid];
    
    BOOL r = [MMCommon isExistDocsModel:[self getWebSite] folderName:folderName fileName:fileName];
    if (r) {
        return TRUE;
    }
    return FALSE;
}

@end
