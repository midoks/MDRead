//
//  MMSourceListModel.m
//  MDRead
//
//  Created by midoks on 2017/6/19.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMSourceListModel.h"
#import "MMCommon.h"

@interface MMSourceListModel() <NSCoding>

@end

@implementation MMSourceListModel

-(id)init
{
    self = [super init];
    [self readModel];
    return self;
}

#pragma mark - NSCoding -
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_list forKey:@"list"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _list = [aDecoder decodeObjectForKey:@"list"];
    return self;
}


+(MMSourceListModel*)shareInstance
{
    static  MMSourceListModel *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMSourceListModel alloc] init];
    });
    return shareInstance;
}

-(void)readModel
{
    if ([self isExistDocsModel:@"source_list"]) {
        MMSourceListModel *m = [self docsModelGet:@"source_list"];
        _list = m.list;
    } else {
        _list = [[NSMutableArray alloc] init];
        [self save];
    }
}

-(MMSourceModel *)getCurrent
{
    NSUInteger list_c = [_list count];
    if (list_c > 0){
        for (int i = 0;  i < [_list count]; i++) {
           MMSourceModel *s = [_list objectAtIndex:i];
            if (s.selected){
                return s;
            }
        }
    }
    return nil;
}

-(void)setCurrent:(NSInteger)row
{
    NSUInteger list_c = [_list count];
    if (list_c > 0){
        for (int i = 0;  i < [_list count]; i++) {
            [[_list objectAtIndex:i] setSelected:NO];
        }
    }
    
    [[_list objectAtIndex:row] setSelected:YES];
    [self save];
}


-(void)addSource:(NSString *)website title:(NSString *)title
{
    MMSourceModel * s = [[MMSourceModel alloc] init];
    
    s.website = website;
    s.title = title;
    s.selected = YES;

    NSUInteger list_c = [_list count];
    if (list_c > 0){
        for (int i = 0;  i < [_list count]; i++) {
            [[_list objectAtIndex:i] setSelected:NO];
        }
    }
    
    [_list addObject:s];
    
    [self save];
}

-(void)save
{
    [self docsModelSave:@"source_list" object:self];
}

-(void)dealloc
{
    //[super dealloc];
    MDLog(@"%@", @"MMSourceListModel -- dealloc --- ");
    [self save];
}


#pragma mark - Private Methods -

#pragma mark - 文档保存 -
-(BOOL)docsModelSave:(NSString *)fileName object:(NSObject *)object
{
    NSString *docsPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    if( [MMCommon createFilePath:docsPath] ){
        docsPath = [NSString stringWithFormat:@"%@/%@.txt", docsPath, fileName];
        [NSKeyedArchiver archiveRootObject:object toFile:docsPath];
    }
    return TRUE;
}

#pragma mark - 读取文档 -
-(id)docsModelGet:(NSString *)fileName
{
    NSString *docsPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    docsPath = [NSString stringWithFormat:@"%@/%@.txt", docsPath, fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:docsPath];
}


#pragma mark - 文档判断 -
-(BOOL)isExistDocsModel:(NSString *)fileName
{
    NSString *docsPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    docsPath = [NSString stringWithFormat:@"%@/%@.txt", docsPath, fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:docsPath];
}


@end
