//
//  MMBookInstroCell.m
//  MDRead
//
//  Created by midoks on 16/8/30.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookInstroCell.h"
#import "MMCommon.h"

@interface MMBookInstroCell()

//@property (nonatomic, assign) Boolean enableStatus;

@end

@implementation MMBookInstroCell


+(id)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"MMBookInstroCell";
    MMBookInstroCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[MMBookInstroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
        _enableStatus = TRUE;
    }
    return self;
}

-(void)initView
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MDDeviceW, 0.5)];
    line.layer.opacity = 0.3;
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
    
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 18, 18)];
    _icon.image = [UIImage imageNamed:@"md_chapter_new"];
    [self.contentView addSubview:_icon];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 50, 18)];
    _title.font = [UIFont systemFontOfSize:14];
    _title.text = @"最新";
    [self.contentView addSubview:_title];
    
    _desc = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 18)];
    _desc.font = [UIFont systemFontOfSize:12];
    _desc.textColor = [UIColor grayColor];
    _desc.text = @"描述";
    [self.contentView addSubview:_desc];
    
    _status = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 30, 18)];
    _status.font = [UIFont systemFontOfSize:14];
    _status.text = @"状态";
    _status.textColor = [UIColor blueColor];
    [self.contentView addSubview:_status];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger h = self.frame.size.height;
    NSInteger cellX = (h-18)/2;
    
    _icon.frame = CGRectMake(15, cellX, 18, 18);
    _title.frame = CGRectMake(40, cellX, 50, 18);
    
    _desc.frame = CGRectMake(90, cellX, 100, 18);
    
    if (_enableStatus) {
        _status.frame = CGRectMake(self.frame.size.width - 70, cellX, 50, 18);
    } else {
        [_status removeFromSuperview];
    }
}

@end
