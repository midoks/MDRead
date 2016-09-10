//
//  MMUILabel+textSize.m
//  MDRead
//
//  Created by midoks on 16/4/24.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMUILabel+textSize.h"

@implementation UILabel(textSize)


-(CGSize)textSize:(UIFont *)font size:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGRect rsize = [self.text boundingRectWithSize:size
                                      options: NSStringDrawingUsesLineFragmentOrigin //| NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                   attributes: attribute
                                      context:nil];
    CGSize r = CGSizeMake(ceil(rsize.size.width), ceil(rsize.size.height));
    return r;
}

-(CGSize)textSize:(UIFont *)font width:(CGFloat)width
{
    return [self textSize:font size:CGSizeMake(width, CGFLOAT_MAX)];
}

@end
