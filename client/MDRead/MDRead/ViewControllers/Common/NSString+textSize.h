//
//  NSString+TextSize.h
//  MDRead
//
//  Created by midoks on 16/4/17.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(textSize)

-(CGSize)textSize:(UIFont *)font size:(CGSize)size;
-(CGSize)textSize:(UIFont *)font width:(CGFloat)width;

@end
