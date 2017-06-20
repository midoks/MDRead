//
//  MMReadRecordModel.m
//  MDRead
//
//  Created by midoks on 2017/6/10.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadRecordModel.h"

@interface MMReadRecordModel() <NSCoding>
@end



@implementation MMReadRecordModel


-(id)init
{
    self = [super init];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    _chapter_pos = [aDecoder decodeIntegerForKey:@"chapter_pos"];
    _chapter_page_pos = [aDecoder decodeIntegerForKey:@"chapter_page_pos"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_chapter_pos forKey:@"chapter_pos"];
    [aCoder encodeInteger:_chapter_page_pos forKey:@"chapter_page_pos"];
}

-(NSString *)description
{
    NSString *desc = @"MMReadRecordModel:";
    
    desc = [NSString stringWithFormat:@"%@\n _chapter_pos:%lud", desc, _chapter_pos];
    desc = [NSString stringWithFormat:@"%@\n _chapter_page_pos:%lud", desc, _chapter_page_pos];
    
    return desc;
}

@end
