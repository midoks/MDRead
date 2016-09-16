//
//  MMBookInstroTextCell.m
//  MDRead
//
//  Created by midoks on 16/9/14.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookInstroTextCell.h"
#import "NSString+textSize.h"

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
    NSLog(@"%@", _desc);
    
    
    CGSize p = [_desc textSize:[UIFont systemFontOfSize:16] size:CGSizeMake(100, 200)];
    
    NSLog(@"%@", NSStringFromCGSize(p));
    return p.height;
}




@end
