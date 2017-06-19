//
//  MMSourceListModel.m
//  MDRead
//
//  Created by midoks on 2017/6/19.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMSourceListModel.h"

@interface MMSourceListModel() <NSCoding>

@end

@implementation MMSourceListModel

-(id)init
{
    self = [super init];
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

@end
