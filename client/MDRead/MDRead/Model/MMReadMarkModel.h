//
//  MMReadMarkModel.h
//  MDRead
//
//  Created by midoks on 2017/6/10.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMReadMarkModel : NSObject

@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, strong) NSString *chapter_id;
@property (nonatomic, strong) NSString *chapter_content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *location;

@end
