//
//  MMReadMarkModel.m
//  MDRead
//
//  Created by midoks on 2017/6/10.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadMarkModel.h"

@interface MMReadMarkModel() <NSCoding>


@end

@implementation MMReadMarkModel

-(id)init
{
    self = [super init];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    _book_id = [aDecoder decodeObjectForKey:@"book_id"];
    _chapter_id = [aDecoder decodeObjectForKey:@"chapter_id"];
    _chapter_content = [aDecoder decodeObjectForKey:@"chapter_content"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_book_id forKey:@"book_id"];
    [aCoder encodeObject:_chapter_id forKey:@"chapter_id"];
    [aCoder encodeObject:_chapter_content forKey:@"chapter_content"];
}

@end
