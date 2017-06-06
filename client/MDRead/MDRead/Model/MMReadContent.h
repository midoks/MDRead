//
//  MMReadContent.h
//  MDRead
//
//  Created by midoks on 2017/6/3.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMReadChapterModel.h"

@interface MMReadContent : NSObject

+(MMReadContent*)shareInstance;

@property (nonatomic, strong) NSString *content;

-(void)getChapterInfo:(MMReadChapterModel *)chapterInfo
              success:(void (^)(id responseObject))success
              failure:(void (^)(int ret_code, NSString *ret_msg))failure;

@end
