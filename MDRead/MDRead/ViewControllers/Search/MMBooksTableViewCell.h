//
//  MMBooksTableViewCell.h
//  MDRead
//
//  Created by midoks on 16/6/25.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^mdItemClick)();

@interface MMBooksTableViewCell : UITableViewCell

@property(nonatomic, assign) NSInteger numRows;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) UILabel *sectionTitle;

-(void)initRecommendData:(void (^)())success;
-(NSInteger)recommendHeight;

-(void)initRandData:(void (^)())success;
-(NSInteger)randHeight;

-(void)itemClick:(mdItemClick)block;


@end
