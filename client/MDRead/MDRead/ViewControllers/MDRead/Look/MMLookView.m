//
//  MMLookView.m
//  MDRead
//
//  Created by midoks on 16/9/25.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMLookView.h"

@implementation MMLookView

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
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    t.text = @"page:";
    t.backgroundColor = [UIColor yellowColor];
    [self addSubview:t];
}


@end
