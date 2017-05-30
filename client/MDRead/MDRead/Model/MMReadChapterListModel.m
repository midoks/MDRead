//
//  MMReadChapterListModel.m
//  MDRead
//
//  Created by midoks on 2017/5/29.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadChapterListModel.h"

@interface MMReadChapterListModel() <NSCoding>

@property (nonatomic,strong) NSString *bid;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *name;

@end

@implementation MMReadChapterListModel

-(id)init
{
    self = [super init];

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    MDLog(@"MMReadChapterListModel initWithCoder");
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    MDLog(@"MMReadChapterListModel encodeWithCoder");


}



@end
