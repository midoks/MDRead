//
//  MMBookCell.m
//  MDRead
//
//  Created by midoks on 16/8/20.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookCell.h"

@implementation MMBookCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        self.bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, CGRectGetWidth(self.frame)-2,CGRectGetHeight(self.frame)-33)];
        self.bookImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.bookImageView];
        
        self.bookName = [[UILabel alloc] initWithFrame:CGRectMake(1, CGRectGetHeight(self.frame)-30, CGRectGetWidth(self.frame)-2, 30)];
        self.bookName.text = @"--加载中--";
        self.bookName.numberOfLines = 0;
        self.bookName.lineBreakMode = NSLineBreakByWordWrapping;
        self.bookName.font = [UIFont systemFontOfSize:12];
        //self.bookName.backgroundColor = [UIColor redColor];
        [self addSubview:self.bookName];
    }
    return self;
}

@end
