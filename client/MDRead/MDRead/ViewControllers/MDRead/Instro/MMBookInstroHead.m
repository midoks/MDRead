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
        self.frame = CGRectMake(0, 0, MDDeviceW, 200);
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
    }
    return self;
}


-(void)initView
{
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MDDeviceW, 150)];
    back.backgroundColor = [UIColor blueColor];
    [self addSubview:back];
}





@end
