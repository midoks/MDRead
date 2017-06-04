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
        
        self.backgroundColor = [UIColor whiteColor];
        [self initClickButton];
        [self initHeadLine];
    }
    return self;
}

-(void)initHeadLine
{
    //上面一笔
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, self.frame.size.width, 0.5)];
    topLine.layer.opacity = 0.4;
    topLine.backgroundColor = [UIColor grayColor];
    [self addSubview:topLine];
    
    //中间一笔
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 0.5, self.frame.size.height/4, 1, self.frame.size.height/2)];
    centerLine.layer.opacity = 0.4;
    centerLine.backgroundColor = [UIColor grayColor];
    [self addSubview:centerLine];
}

-(void)initClickButton
{
    NSInteger w = self.frame.size.width/2;
    
    
    UIButton *addBook = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, self.frame.size.height)];
    addBook.tag = 0;
    [addBook setTitle:@"阅读" forState:UIControlStateNormal];
    //[addBook setTintColor:[UIColor cyanColor]];
//    addBook.tintColor = [UIColor colorWithRed:30/255 green:138/255 blue:230/255 alpha:1];
    addBook.titleLabel.font = [UIFont systemFontOfSize:16];
    addBook.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
//    [addBook setTitleColor:[UIColor colorWithRed:55/255 green:138/255 blue:230/255 alpha:1] forState:UIControlStateNormal];
    [addBook setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addBook addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBook];
    
    
    UIButton *readBook = [[UIButton alloc] initWithFrame:CGRectMake(w, 0, w, self.frame.size.height)];
    readBook.tag = 1;
    [readBook setTitle:@"加入书架" forState:UIControlStateNormal];
    readBook.titleLabel.font = [UIFont systemFontOfSize:16];
    readBook.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [readBook setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [readBook addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:readBook];
}

-(void)btnClick:(MMInstroClick)block
{
    self.btnClick = block;
}

-(void)btnItemClick:(UIButton *)s
{
    if(_btnClick){
        if (s.tag == 0) {
            _btnClick(MMInstroItemRead);
        } else if ( s.tag == 1 ){
            _btnClick(MMInstroItemAdd);
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
