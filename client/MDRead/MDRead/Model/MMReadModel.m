//
//  MMReadModel.m
//  MDRead
//
//  Created by midoks on 2017/5/27.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadModel.h"

@interface MMReadModel()

@end

@implementation MMReadModel

-(id)init
{
    if(self = [super init]){
    
    }
    return self;
}


+(MMReadModel*)shareInstance
{
    static  MMReadModel *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMReadModel alloc] init];
    });
    return shareInstance;
}


#pragma mark - 基础操作 -

#pragma mark 读取文件
-(void)readFileBook
{
    


}

#pragma mark 是否存在文件数据
-(BOOL)isExistFileBook
{
    

    return FALSE;
}


@end
