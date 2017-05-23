//
//  MMBookInstroHead.m
//  MDRead
//
//  Created by midoks on 16/8/24.
//  Copyright © 2016年 midoks. All rights reserved.
//


#import "MMCommon.h"
#import "MMBookInstroHead.h"
#import "UIImageView+WebCache.h"

@interface MMBookInstroHead()

@property (nonatomic, strong) MMBookHeadItemClick btnClick;

@end

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
    
    UIView *bookOther = [[UIView alloc] initWithFrame:CGRectMake(0, [self viewPosY:_bDesc], MD_DW, 50)];
    
    //其他信息
    CGFloat bookBottomWith = MD_DW / 2;
    

    //目录
    UIButton *goList = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bookBottomWith, 50)];
    [goList setTitle:@"目录" forState:UIControlStateNormal];
    [goList setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    goList.titleLabel.font = [UIFont systemFontOfSize:14];
    [goList setImage:[UIImage imageNamed:@"md_button_status"] forState:UIControlStateNormal];
    [goList setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    goList.tag = 0;
    [bookOther addSubview:goList];
    
    //阅读状态
    UIButton *goStatus = [[UIButton alloc] initWithFrame:CGRectMake(bookBottomWith, 0, bookBottomWith, 50)];
    [goStatus setTitle:@"在读" forState:UIControlStateNormal];
    [goStatus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    goStatus.titleLabel.font = [UIFont systemFontOfSize:14];
    [goStatus setImage:[UIImage imageNamed:@"md_button_status"] forState:UIControlStateNormal];
    [goStatus setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    goStatus.tag = 1;
    [bookOther addSubview:goStatus];
    
    //点击
    [goList addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [goStatus addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:bookOther];
}

-(void)btnClick:(MMBookHeadItemClick)block
{
    _btnClick = block;
}


-(void)btnItemClick:(UIButton *)s
{
    if (_btnClick){
        if (s.tag == 0) {
            _btnClick(MMBookHeadItemList);
        } else {
            _btnClick(MMBookHeadItemStatus);
        }
    }
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
