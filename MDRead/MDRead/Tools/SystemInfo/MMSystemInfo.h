//
//  MMSystemInfo.h
//  MDRead
//
//  Created by midoks on 16/8/4.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMSystemInfo : NSObject

+(MMSystemInfo*)shareInstance;


-(NSMutableDictionary *) getInfo;

@end
