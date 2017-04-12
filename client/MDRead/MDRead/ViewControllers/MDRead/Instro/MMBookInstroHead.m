//
//  MMBookInstroHead.m
//  MDRead
//
//  Created by midoks on 16/8/24.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookInstroHead.h"
#import "MMCommon.h"

@implementation MMBookInstroHead

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, MD_DW, 400);
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(float)viewPosY:(UIView *)view
{
    return view.frame.origin.y + view.frame.size.height;
}


-(void)initView
{
    
    UIImageView *bookImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 140, 200)];
    bookImage.image = [UIImage imageNamed:@"books_test"];
    [self addSubview:bookImage];
    
    //NSLog(@"%@",  NSStringFromCGPoint(self.center) );
    
    bookImage.center = CGPointMake(self.center.x, 0);
    bookImage.frame = CGRectMake(bookImage.frame.origin.x, 20, bookImage.frame.size.width, bookImage.frame.size.height);
    
    //标题
    UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, [self viewPosY:bookImage] + 10, MD_DW, 30)];
    bookTitle.text = @"嫌疑犯X的献身";
    bookTitle.font = [UIFont systemFontOfSize:24];
    bookTitle.textAlignment = NSTextAlignmentCenter;
    //bookTitle.backgroundColor = [UIColor blueColor];
    [self addSubview:bookTitle];
    
    //作者
    UILabel *bookAuthor = [[UILabel alloc] initWithFrame:CGRectMake(0, [self viewPosY:bookTitle] + 5, MD_DW, 20)];
    bookAuthor.text = @"东野圭吾";
    [bookAuthor setFont:[UIFont systemFontOfSize:16]];
    bookAuthor.textColor = [UIColor blueColor];
    bookAuthor.textAlignment = NSTextAlignmentCenter;
    [self addSubview:bookAuthor];
//
//    UILabel *bookType = [[UILabel alloc] initWithFrame:CGRectMake(130, 70, MD_DW - 120, 20)];
//    bookType.text = @"仙侠";
//    [bookType setFont:[UIFont systemFontOfSize:14]];
//    [self addSubview:bookType];
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}





@end
