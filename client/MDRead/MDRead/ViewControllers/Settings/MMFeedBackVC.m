//
//  MMFeedBackVC.m
//  MDRead
//
//  Created by midoks on 2017/6/23.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMFeedBackVC.h"
#import "MMNovelApi.h"
#import "MMCommon.h"

@interface MMFeedBackVC () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *feed;
@property (nonatomic, strong) UILabel *residue;
@property (nonatomic, strong) UILabel *notice;

@end

@implementation MMFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}


-(void)initUI
{
    _notice = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, MD_W - 20, 20)];
    _notice.text = @"请输入你的意见最多240字";
    _notice.font = [UIFont systemFontOfSize:12];
    _notice.textColor = [UIColor redColor];
    _notice.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_notice];
    
    
    _feed = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, MD_W - 20, 200)];
    _feed.textAlignment = NSTextAlignmentLeft;
    _feed.font = [UIFont systemFontOfSize:14];
    _feed.delegate = self;
    _feed.editable = YES;
    _feed.layer.borderWidth = 0.5;
    _feed.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _feed.layer.cornerRadius = 5.0;
    [self.view addSubview:_feed];
    
    
    _residue = [[UILabel alloc] initWithFrame:CGRectMake(_feed.frame.size.width - 50, _feed.frame.size.height - 20, 50, 20)];
    _residue.backgroundColor = [UIColor clearColor];
    _residue.font = [UIFont fontWithName:@"Arial" size:12.0f];
    _residue.text = @"240/240";
    _residue.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    [_feed addSubview:_residue];
    
    UIButton *s =  [[UIButton alloc] initWithFrame:CGRectMake(10, _feed.frame.origin.y  + _feed.frame.size.height + 10, MD_W - 20, 40)];
    [s setTitle:@"提交" forState:UIControlStateNormal];
    [s setBackgroundColor:[UIColor blueColor]];
    s.layer.cornerRadius = 3;
    [s addTarget:self action:@selector(toActionData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:s];
    
    

}

-(void)toActionData
{

    NSString *content = _feed.text;
    if ([content isEqualToString:@""]){
        [MMCommon showMessage:@"内容不能为空!"];
        return;
    }
    
    
    [[MMNovelApi shareInstance] feedBack:content success:^(id responseObject) {
        [MMCommon showMessage:@"反馈成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(int ret_code, NSString *ret_msg) {
        [MMCommon showMessage:@"反馈成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UITextViewDelegate -
-(void) textViewDidChange:(UITextView*)textView
{
    if([textView.text length] == 0){
        //self.placeHolderLabel.text = @"请输入你的意见最多140字";
    }else{
        //self.placeHolderLabel.text = @"";//这里给空
    }
    
    //计算剩余字数,不需要的也可不写
    NSString *nsTextCotent = textView.text;
    NSInteger existTextNum = [nsTextCotent length];
    NSInteger remainTextNum = 240 - existTextNum;
    _residue.text = [NSString stringWithFormat:@"%ld/240",(long)remainTextNum];
}

-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }
    
    if (range.location >= 240) {
        return NO;
    }else {
        return YES;
    }
}


@end
