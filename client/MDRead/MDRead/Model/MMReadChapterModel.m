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


-(id)initWithCoder:(NSCoder *)aDecoder
{
    _bid = [aDecoder decodeObjectForKey:@"bid"];
    _cid = [aDecoder decodeObjectForKey:@"cid"];
    _sid = [aDecoder decodeObjectForKey:@"sid"];
    _name = [aDecoder decodeObjectForKey:@"name"];
    _cache = [aDecoder decodeObjectForKey:@"cache"];
    //MDLog(@"_cache:initWithCoder:%@", _cache);
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_bid forKey:@"bid"];
    [aCoder encodeObject:_cid forKey:@"cid"];
    [aCoder encodeObject:_sid forKey:@"sid"];
    [aCoder encodeObject:_name forKey:@"name"];
    //MDLog(@"_cache:encodeWithCoder:%@", _cache);
    [aCoder encodeObject:_cache forKey:@"cache"];
    
}

@end
