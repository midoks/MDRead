//
//  MMReadModel.h
//  MDRead
//
//  Created by midoks on 2017/5/27.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMReadChapterModel.h"

@interface MMReadModel : NSObject 

@property (nonatomic, strong) NSDictionary *bookInfo;
@property (nonatomic, strong) NSMutableArray<MMReadChapterModel *> *chapterList;

+(MMReadModel*)shareInstance;

-(void)parseBookList:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)parseBookContent:(void (^)(id responseObject))success
                failure:(void (^)(int ret_code, NSString *ret_msg))failure;
@end
