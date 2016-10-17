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
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MD_FW, MD_FH)];
    t.text = @"page:";
    t.backgroundColor = [UIColor yellowColor];
    [self addSubview:t];
    
//    AVSpeechSynthesizer *synthesize = [[AVSpeechSynthesizer alloc]init];
//    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"不可以"];
//    [synthesize speakUtterance:utterance];
}


@end
