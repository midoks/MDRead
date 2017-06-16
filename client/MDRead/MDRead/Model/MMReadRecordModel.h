//
//  MMReadRecordModel.h
//  MDRead
//
//  Created by midoks on 2017/6/10.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMReadRecordModel : NSObject


@property (nonatomic, assign) NSUInteger chapter_pos;
@property (nonatomic, assign) NSUInteger chapter_page_pos;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *location;

@end
