//
//  MMReadModel.h
//  MDRead
//
//  Created by midoks on 2017/5/27.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMReadChapterModel.h"
#import "MMReadRecordModel.h"

@interface MMReadModel : NSObject 

@property (nonatomic, strong) NSDictionary *bookInfo;
@property (nonatomic, strong) NSMutableArray<MMReadChapterModel *> *chapterList;
@property (nonatomic, strong) MMReadRecordModel *record;

+(MMReadModel*)shareInstance;

-(void)getBookList:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)getBookContent:(void (^)(id responseObject))success
                failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)goBookChapter:(NSUInteger)chapter_pos
                page:(NSUInteger)page_pos
             success:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;
@end
