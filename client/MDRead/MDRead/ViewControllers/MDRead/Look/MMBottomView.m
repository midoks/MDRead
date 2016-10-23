//
//  MMBottomView.m
//  MDRead
//
//  Created by midoks on 2016/10/12.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBottomView.h"
#import "MMButton.h"

@interface MMBottomView()

@end

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
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = _item.count;
    NSInteger viewW = MD_FW/count;
    
    for (NSInteger item = 0; item < count; item++) {
        //test
//      UIButton *icon = [[MMButton alloc] initWithFrame:CGRectMake(item * viewW, 0, viewW, MD_FH)];
//      [icon setImage:[UIImage imageNamed:@"md_r_dirlist"] forState:UIControlStateNormal];
//      [icon setTitle:@"目录" forState:UIControlStateNormal];
        
        MMButton *icon = _item[item];
        
        icon.frame = CGRectMake(item * viewW, 0, viewW, MD_FH);
        [icon setTintColor:[UIColor whiteColor]];
        icon.titleLabel.textAlignment = NSTextAlignmentCenter;
        icon.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [self addSubview:icon];
    }
    
}


@end
