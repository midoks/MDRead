//
//  MMReadModel.h
//  MDRead
//
//  Created by midoks on 2017/5/27.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMReadModel : NSObject 

+(MMReadModel*)shareInstance;

-(MMReadModel *)readModel;

-(void)parseBookList:(NSString *)book_id
           source_id:(NSString *)source_id
             success:(void (^)(id responseObject))success
             failure:(void (^)(int ret_code, NSString *ret_msg))failure;

-(void)parseBookContent:(NSString *)book_id
              source_id:(NSString *)source_id
                success:(void (^)(id responseObject))success
                failure:(void (^)(int ret_code, NSString *ret_msg))failure;
@end
