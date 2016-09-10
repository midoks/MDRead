//
//  MMBookInstroCell.h
//  MDRead
//
//  Created by midoks on 16/8/30.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBookInstroCell : UITableViewCell

+(id)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) Boolean enableStatus;

@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *status;
@property(nonatomic, strong) UILabel *desc;

@end
