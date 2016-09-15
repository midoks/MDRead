//
//  MMBookInstroTextCell.m
//  MDRead
//
//  Created by midoks on 16/9/14.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookInstroTextCell.h"

@implementation MMBookInstroTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    }
    return self;
}


-(void)setDesc:(NSString *)desc
{
    _desc = desc;
}

-(NSInteger)getDescSize
{
    
    
    return 44;
}




@end
