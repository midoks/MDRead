//
//  MMSimPagesVC.m
//  MDRead
//
//  Created by midoks on 2016/10/15.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSimPagesVC.h"
#import <AVFoundation/AVFoundation.h>

@interface MMSimPagesVC ()

@end

@implementation MMSimPagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initPageTitle];
    [self initPageContent];
    [self initPageBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 初始化标题 -
-(void) initPageTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, MD_W - 40, 10)];
    [title setText:@"第二章 活着的艰难"];
    [title setTextColor:[UIColor grayColor]];
    [title setFont:[UIFont systemFontOfSize:10.0]];
    [self.view addSubview:title];
}


-(void) initPageContent
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"txt"];
    NSString *_content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _content = [_content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    _content = [_content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    _content = [_content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];

    _content = [_content substringFromIndex:8];
    
    NSLog(@"content:\n%@", _content);
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, MD_W - 40, MD_H - 70)];
    label.text = self.dataObject;
    label.font = [UIFont fontWithName:@"Helvetica" size:19.f];
    label.numberOfLines = 0;
    label.text = _content;
    label.layer.opacity = 0.8;
    [self.view addSubview:label];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:label.font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1.5f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:_content attributes:dic];
    label.attributedText = attributeStr;
    
//    AVSpeechSynthesizer *synthesize = [[AVSpeechSynthesizer alloc]init];
//    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:_content];
//    [synthesize speakUtterance:utterance];
}


-(void)initPageBottom
{
    UILabel *bLeft = [[UILabel alloc] initWithFrame:CGRectMake(20, MD_H - 25, (MD_W - 40)/2, 20)];
    [bLeft setText:@"3/9 1.0%"];
    [bLeft setTextColor:[UIColor blackColor]];
    [bLeft setTextColor:[UIColor grayColor]];
    [bLeft setFont:[UIFont systemFontOfSize:10.0]];
    [self.view addSubview:bLeft];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    
    UILabel *bRight = [[UILabel alloc] initWithFrame:CGRectMake(20 + (MD_W - 40)/2, MD_H - 25, (MD_W - 40)/2, 20)];
    [bRight setText:dateString];
    [bRight setTextColor:[UIColor grayColor]];
    [bRight setFont:[UIFont systemFontOfSize:10.0]];
    bRight.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:bRight];
    
}

@end
