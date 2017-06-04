//
//  MMReadContent.m
//  MDRead
//
//  Created by midoks on 2017/6/3.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadContent.h"
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
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

#pragma mark - 获取文章内容 -
-(void)getContent:(NSDictionary *)booInfo
          success:(void (^)(id responseObject))success
          failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{


}

@end
