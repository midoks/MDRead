//
//  MMBookshelfCollectionViewCell.m
//  MDRead
//
//  Created by midoks on 16/6/25.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookshelfCollectionViewCell.h"

@implementation MMBookshelfCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.backgroundColor = [UIColor purpleColor];
        //self.backgroundColor = [UIColor blueColor];
        
        self.bookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, CGRectGetWidth(self.frame)-6, CGRectGetHeight(self.frame)-38)];
        self.bookImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.bookImageView];
        
        self.bookName = [[UILabel alloc] initWithFrame:CGRectMake(3, CGRectGetHeight(self.frame)-35, CGRectGetWidth(self.frame)-6, 20)];
        self.bookName.text = @"凡人修仙传";
        self.bookName.font = [UIFont systemFontOfSize:12];
        //self.bookName.backgroundColor = [UIColor redColor];
        [self addSubview:self.bookName];
        
        
        self.bookStatus = [[UILabel alloc] initWithFrame:CGRectMake(3, CGRectGetHeight(self.frame)-20, (CGRectGetWidth(self.frame)-6)/2, 20)];
        self.bookStatus.text = @"完结";
        self.bookStatus.font = [UIFont systemFontOfSize:10];
        self.bookStatus.textColor = [UIColor grayColor];
        //self.bookStatus.backgroundColor = [UIColor grayColor];
        [self addSubview:self.bookStatus];
        
        self.bookReadStatus = [[UILabel alloc] initWithFrame:CGRectMake(3 + (CGRectGetWidth(self.frame)-6)/2, CGRectGetHeight(self.frame)-20, (CGRectGetWidth(self.frame)-6)/2, 20)];
        self.bookReadStatus.text = @"已读0.1%";
        self.bookReadStatus.textAlignment = NSTextAlignmentRight;
        self.bookReadStatus.font = [UIFont systemFontOfSize:10];
        self.bookReadStatus.textColor = [UIColor grayColor];
        [self addSubview:self.bookReadStatus];
        
    }
    return self;
}

@end
