//
//  MMSourceModel.m
//  MDRead
//
//  Created by midoks on 2017/6/19.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMSourceModel.h"

@interface MMSourceModel()

@end

@implementation MMSourceModel

#pragma mark - NSCoding -
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_website forKey:@"website"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeBool:_selected forKey:@"selected"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    _selected = [aDecoder decodeBoolForKey:@"selected"];
    _website = [aDecoder decodeObjectForKey:@"website"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    return self;
}

@end
