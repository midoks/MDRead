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
        self.frame = CGRectMake(0, 0, MD_DW, 380);
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
    [bookAuthor setFont:[UIFont systemFontOfSize:14]];
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
    
    //其他信息
    CGFloat bookBottomWith = MD_DW / 3;
    
    UIView *bookOther = [[UIView alloc] initWithFrame:CGRectMake(0, [self viewPosY:bookDesc], MD_DW, 50)];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bookBottomWith, 50)];
    
    //阅读状态
    [leftButton setTitle:@"在读" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton setImage:[UIImage imageNamed:@"md_button_status"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [bookOther addSubview:leftButton];
    
    
    //目录
    UIButton *centerButon = [[UIButton alloc] initWithFrame:CGRectMake(bookBottomWith, 0, bookBottomWith, 50)];
    [centerButon setTitle:@"目录" forState:UIControlStateNormal];
    [centerButon setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    centerButon.titleLabel.font = [UIFont systemFontOfSize:14];
    [centerButon setImage:[UIImage imageNamed:@"md_button_status"] forState:UIControlStateNormal];
    [centerButon setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [bookOther addSubview:centerButon];
    
    //书籍信息
    UIButton *rightButon = [[UIButton alloc] initWithFrame:CGRectMake(bookBottomWith*2, 0, bookBottomWith, 50)];
    [rightButon setTitle:@"信息" forState:UIControlStateNormal];
    [rightButon setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightButon.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButon setImage:[UIImage imageNamed:@"md_button_status"] forState:UIControlStateNormal];
    [rightButon setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [bookOther addSubview:rightButon];

    [self addSubview:bookOther];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
}





@end
