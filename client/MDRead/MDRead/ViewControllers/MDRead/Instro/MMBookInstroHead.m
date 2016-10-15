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
    
}





@end
