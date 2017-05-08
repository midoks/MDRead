//
//  MMBookInstroHead.m
//  MDRead
//
//  Created by midoks on 16/8/24.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookInstroHead.h"
#import "MMCommon.h"

#import "UIImageView+WebCache.h"

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
    
    _bImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 140, 200)];
    //_bImage.image = [UIImage imageNamed:@"books_test"];
    [self addSubview:_bImage];
    
    _bImage.center = CGPointMake(self.center.x, 0);
    _bImage.frame = CGRectMake(_bImage.frame.origin.x, 20, _bImage.frame.size.width, _bImage.frame.size.height);
    
    //标题
    _bTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, [self viewPosY:_bImage] + 10, MD_DW, 30)];
    _bTitle.text = @"---";
    _bTitle.font = [UIFont systemFontOfSize:24];
    _bTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_bTitle];
    
    //作者
    _bAuthor = [[UILabel alloc] initWithFrame:CGRectMake(0, [self viewPosY:_bTitle] + 5, MD_DW, 20)];
    _bAuthor.text = @"---";
    [_bAuthor setFont:[UIFont systemFontOfSize:14]];
    _bAuthor.textColor = [UIColor blueColor];
    _bAuthor.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_bAuthor];
    
    //描述
    _bDesc = [[UILabel alloc] initWithFrame:CGRectMake(15, [self viewPosY:_bAuthor] + 5, MD_DW - 30, 40)];
    _bDesc.text = @"---";
    [_bDesc setFont:[UIFont systemFontOfSize:14]];
    _bDesc.numberOfLines = 0;
    _bDesc.textColor = [UIColor blackColor];
    _bDesc.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_bDesc];
    
    //其他信息
    CGFloat bookBottomWith = MD_DW / 3;
    
    UIView *bookOther = [[UIView alloc] initWithFrame:CGRectMake(0, [self viewPosY:_bDesc], MD_DW, 50)];
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
    
//    _bImage.frame = CGRectMake(10, 10, 140, 200);
//    _bImage.center = CGPointMake(self.center.x, 0);
//    _bImage.frame = CGRectMake(_bImage.frame.origin.x, 20, _bImage.frame.size.width, _bImage.frame.size.height);
//    
//    //标题
    _bTitle.frame = CGRectMake(0, [self viewPosY:_bImage] + 10, MD_DW, 30);
    _bTitle.font = [UIFont systemFontOfSize:24];
    _bTitle.textAlignment = NSTextAlignmentCenter;
    
    
    
    
}





@end
