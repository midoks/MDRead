//
//  MMBookInstroTextCell.h
//  MDRead
//
//  Created by midoks on 16/9/14.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBookInstroTextCell : UITableViewCell


@property(nonatomic, strong) NSString *desc;
-(void)setDesc:(NSString *)desc;
-(NSInteger)getDescSize;

@end
