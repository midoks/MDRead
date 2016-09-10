//
//  NSString+TextSize.m
//  MDRead
//
//  Created by midoks on 16/4/17.
//  Copyright © 2016年 midoks. All rights reserved.
//



#import "NSString+textSize.h"

@implementation NSString(textSize)


-(CGSize)textSize:(UIFont *)font size:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGRect rsize = [self boundingRectWithSize:size
                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading //| NSStringDrawingUsesDeviceMetrics //| NSStringDrawingTruncatesLastVisibleLine
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
