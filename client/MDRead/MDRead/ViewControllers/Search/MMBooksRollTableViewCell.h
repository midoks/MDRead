//
//  MMBookRollTableViewCell.h
//  MDRead
//
//  Created by midoks on 16/6/27.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCommon.h"
#import "MMBooksSrcollView.h"

@interface MMBooksRollTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) UILabel *sectionTitle;
@property(nonatomic, strong) NSMutableArray<MMBooksSrcollView *>* pages;
@property(nonatomic, strong) MMBooksSrcollView *currentPage;

-(NSInteger)rollHeight;
-(void)initRankData;
-(void)setClickBlock:(mdItemClick)block;

@end
