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
    
    //描述
    UILabel *bookDesc = [[UILabel alloc] initWithFrame:CGRectMake(15, [self viewPosY:bookAuthor] + 5, MD_DW - 30, 40)];
    bookDesc.text = @"东野圭吾（ひがしの けいご，Higashino Keigo），日本推理小说作家。1958年2月4日出生于日本大阪。毕业于大阪府立大学电气工学专业，之后在汽车零件供应商日本电装担任生产技术工程师，并进行推理小说的创作。1985年，凭借《放学后》获得第31回江户川乱步奖，从此成为职业作家，开始专职写作。早期作品多为精巧细致的本格推理，后期笔锋愈发老辣，文字鲜加雕琢，叙述简练凶狠，情节跌宕诡异，故事架构几至匪夷所思的地步，擅长从极不合理处写出极合理的故事，作风逐渐超越传统推理小说的框架。";
    [bookDesc setFont:[UIFont systemFontOfSize:14]];
    bookDesc.numberOfLines = 0;
    bookDesc.textColor = [UIColor blackColor];
    bookDesc.textAlignment = NSTextAlignmentLeft;
    [self addSubview:bookDesc];
    
    //目录信息
    
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
