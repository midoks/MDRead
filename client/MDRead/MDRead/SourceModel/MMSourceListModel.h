//
//  MMSourceListModel.h
//  MDRead
//
//  Created by midoks on 2017/6/19.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSourceModel.h"

@interface MMSourceListModel : NSObject

@property (nonatomic, strong) NSMutableArray<MMSourceModel *> *list;

+(MMSourceListModel*)shareInstance;
-(void)addSource:(NSString *)website title:(NSString *)title;
-(void)setCurrent:(NSInteger)row;
-(MMSourceModel *)getCurrent;
-(void)save;

@end
