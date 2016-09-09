//
//  MMBookAuthorCell.h
//  MDRead
//
//  Created by midoks on 16/8/21.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MMAuthorUpdate)();

@interface MMBookAuthorCell : UITableViewCell

+(id)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) UILabel *sectionTitle;

-(NSInteger)authorHeight;
-(void)setData:(id)data;
-(void)reload;


@end
