//
//  MMBookInstroBottom.m
//  MDRead
//
//  Created by midoks on 16/8/23.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookInstroBottom.h"
#import "MMCommon.h"


@interface MMBookInstroBottom()

@property (nonatomic, strong) MMInstroClick btnClick;

@end

@implementation MMBookInstroBottom

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initClickButton];
        [self initHeadLine];
    }
    return self;
}

-(void)initHeadLine
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    line.layer.opacity = 0.3;
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
}

-(void)initClickButton
{
    NSInteger w = self.frame.size.width/2;
    
    
    UIButton *addBook = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, self.frame.size.height)];
    addBook.tag = 0;
    addBook.backgroundColor = [UIColor colorWithRed:102 green:205 blue:170 alpha:0.6];//[UIColor blueColor];
    [addBook setTitle:@"加书架" forState:UIControlStateNormal];
    [addBook setTintColor:[UIColor blueColor]];
    addBook.titleLabel.font = [UIFont systemFontOfSize:16];
    [addBook setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addBook addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBook];
    
    
    //    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(w, 7.5, 0.5, 35)];
    //    line.layer.opacity = 0.3;
    //    line.backgroundColor = [UIColor grayColor];
    //    [self addSubview:line];
    
    
    UIButton *readBook = [[UIButton alloc] initWithFrame:CGRectMake(w, 0, w, self.frame.size.height)];
    readBook.tag = 1;
    [readBook setTitle:@"开始阅读" forState:UIControlStateNormal];
    readBook.titleLabel.font = [UIFont systemFontOfSize:16];
    [readBook setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    readBook.backgroundColor = [UIColor colorWithRed:144.0 green:238.0 blue:144.0 alpha:1.0];//[UIColor colorWithRed:102 green:205 blue:170 alpha:0];
    [readBook addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:readBook];
}

-(void)buttonClick:(MMInstroClick)block
{
    self.btnClick = block;
}

-(void)btnItemClick:(UIButton *)s
{
    if(_btnClick){
        if (s.tag == 0) {
            _btnClick(MMInstroItemAdd);
        } else if ( s.tag == 1 ){
            _btnClick(MMInstroItemRead);
        } else {
            _btnClick(MMInstroItemUnKnow);
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}



@end
