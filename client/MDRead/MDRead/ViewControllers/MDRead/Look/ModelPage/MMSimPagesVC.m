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

@property (nonatomic, strong) UILabel *btitleLabel;
@property (nonatomic, strong) UILabel *bLeftLabel;
@property (nonatomic, strong) UILabel *bTextLabel;

@end

@implementation MMSimPagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initPageTitle];
    [self initPageContent];
    [self initPageBottom];
    
    
    
    MDLog(@"frame:%@", NSStringFromCGRect(self.view.frame));
    
    //self.view.backgroundColor = [UIColor colorWithRed:42/255 green:42/255 blue:42/255 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 初始化标题 -
-(void) initPageTitle
{
    _btitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, MD_W - 40, 10)];
    
    if (_bTitle) {
        [_btitleLabel setText:_bTitle];
    } else {
        [_btitleLabel setText:@"测试"];
    }
    
    [_btitleLabel setTextColor:[UIColor grayColor]];
    [_btitleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self.view addSubview:_btitleLabel];
}


-(void) initPageContent
{
    
    NSString *_content = @"";
    if (!_bContent){
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"txt"];
        _content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    } else {
        _content = _bContent;
    }
    
//    _content = [_content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
//    _content = [_content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
//    _content = [_content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
//    _content = [_content substringFromIndex:8];
    //NSLog(@"content:\n%@", _content);
    
    _bTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, MD_W - 40, MD_H - 70)];
    _bTextLabel.font = [UIFont fontWithName:@"Helvetica" size:19.f];
    _bTextLabel.numberOfLines = 0;
    _bTextLabel.text = _content;
    _bTextLabel.layer.opacity = 1;
    
    
    
    MDLog(@"_bTextLabel:%@", NSStringFromCGRect(_bTextLabel.frame));
    
    //label.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    [self.view addSubview:_bTextLabel];
    //_bLeftLabel.backgroundColor = [UIColor yellowColor];
    
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
    NSDictionary *dic = @{NSFontAttributeName:_bTextLabel.font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1.5f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:_content attributes:dic];
    _bTextLabel.attributedText = attributeStr;
}


-(void)initPageBottom
{
    _bLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MD_H - 25, (MD_W - 40)/2, 20)];
    
    if (_bLeft){
        [_bLeftLabel setText:_bLeft];
    } else {
        [_bLeftLabel setText:@"0/0 0.00%"];
    }
    
    [_bLeftLabel setTextColor:[UIColor blackColor]];
    [_bLeftLabel setTextColor:[UIColor grayColor]];
    [_bLeftLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self.view addSubview:_bLeftLabel];
    
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
