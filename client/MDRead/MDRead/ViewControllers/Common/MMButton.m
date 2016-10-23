//
//  MMButton.m
//  MDRead
//
//  Created by midoks on 2016/10/23.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMButton.h"

@implementation MMButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if( [super initWithFrame:frame]){
        
    }
    return self;
}

#pragma mark - 图片的位置大小 -
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageWH = contentRect.size.height * 0.35;
    CGFloat sep    = (self.frame.size.width - imageWH)/2;
    return CGRectMake(sep, 10, imageWH, imageWH);
}

#pragma mark - 文本的位置大小 -
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat imageWH = self.frame.size.height * 0.35;
    return CGRectMake(0, imageWH + 13, self.frame.size.width, 20);
}

@end
