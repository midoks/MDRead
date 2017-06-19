//
//  MMBooklookViewController.h
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBookBaseLookVC.h"

@interface MMBooklookVC : MMBookBaseLookVC <UIPageViewControllerDataSource>


@property (nonatomic, strong) NSDictionary *bookInfo;

-(void)readBook;

-(id)initWithBookInfo:(NSDictionary *)info;

-(void)goChapter:(NSUInteger)chapter_pos
            page:(NSUInteger)chapter_page
         success:(void (^)(id responseObject))success
         failure:(void (^)(int ret_code, NSString *ret_msg))failure;

@end
