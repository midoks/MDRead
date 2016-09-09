//
//  MMBookRollTableViewCell.h
//  MDRead
//
//  Created by midoks on 16/6/27.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBooksRollTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) UILabel *sectionTitle;
-(void)initRankData;

-(NSInteger)rollHeight;

@end
