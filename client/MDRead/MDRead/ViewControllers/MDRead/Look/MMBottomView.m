//
//  MMBottomView.m
//  MDRead
//
//  Created by midoks on 2016/10/12.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBottomView.h"

@implementation MMBottomView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon
{
    NSInteger pjVIew_h = 44;
    NSInteger pgView_h = MD_FH - pjVIew_h;
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MD_FW, pgView_h)];
    progressView.backgroundColor = [UIColor yellowColor];
    [self addSubview:progressView];
    
    UIView *projectView = [[UIView alloc] initWithFrame:CGRectMake(0, pgView_h, MD_FW, pjVIew_h)];
    projectView.backgroundColor = [UIColor blueColor];
    [self addSubview:projectView];
    
}


@end
