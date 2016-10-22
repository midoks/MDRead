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
        self.frame = CGRectMake(0, 0, MD_DW, 150);
        [self initView];
    }
    return self;
}

-(void)initView
{
    //部分总要数据
    UIView *booInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MD_DW, 150)];
    booInfo.backgroundColor = [UIColor whiteColor];
    [self addSubview:booInfo];
    
    UIImageView *bookImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 125)];
    bookImage.image = [UIImage imageNamed:@"books_test"];
    [booInfo addSubview:bookImage];
    
    
    UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, MD_DW - 120, 20)];
    bookTitle.text = @"不朽烦人";
    [self addSubview:bookTitle];
    
    
    UILabel *bookAuthor = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, MD_DW - 120, 20)];
    bookAuthor.text = @"妄语";
    [bookAuthor setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:bookAuthor];
    
    UILabel *bookType = [[UILabel alloc] initWithFrame:CGRectMake(130, 70, MD_DW - 120, 20)];
    bookType.text = @"仙侠";
    [bookType setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:bookType];

    UILabel *bookStatus = [[UILabel alloc] initWithFrame:CGRectMake(130, 100, MD_DW - 120, 20)];
    bookStatus.text = @"242万字";
    [bookStatus setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:bookStatus];
    
}





@end
