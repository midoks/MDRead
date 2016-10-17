//
//  MMBookBaseLookVC.m
//  MDRead
//
//  Created by midoks on 2016/10/14.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookBaseLookVC.h"
#import "MMBottomView.h"

@interface MMBookBaseLookVC () 

@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) MMBottomView *mmbView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation MMBookBaseLookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setUserInteractionEnabled:YES];
    [self.view setClipsToBounds:YES];
    
    [self initNavBtn];
    [self hiddenNavBtn];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initNavBtn
{
    //普通设置
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"md_back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MD_W, MD_H)];
    [_maskView setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenNavBtn)];
    [_maskView addGestureRecognizer:maskTap];
    
    
    _mmbView = [[MMBottomView alloc] initWithFrame:CGRectMake(0, MD_H, MD_W, 100)];
    [self.view addSubview:_mmbView];
    
    

    //一些特殊设置
    
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MD_W/3, MD_H)];
//    [leftView setBackgroundColor:[UIColor clearColor]];
//    [leftView setUserInteractionEnabled:YES];
//    [leftView setClipsToBounds:YES];
//    [self.view addSubview:leftView];
    
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(MD_W/3, 0, MD_W/3, MD_H)];
    [centerView setUserInteractionEnabled:YES];
    [centerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:centerView];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowView:)];
    _tapGesture.delegate = self;
    [centerView addGestureRecognizer:_tapGesture];
    
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake((MD_W/3)*2, 0, MD_W/3, MD_H)];
//    //[rightView setUserInteractionEnabled:YES];
//    [rightView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:rightView];
//    
//    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextPageView:)];
//    leftTap.delegate = self;
//    [rightView addGestureRecognizer:leftTap];

    
}

-(void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 状态栏设置
- (BOOL)prefersStatusBarHidden
{
    return self.isHidden;
}

-(void)showNavBtn
{
    self.isHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.mmbView setFrame:CGRectMake(0, MD_H - 100, MD_W, 100)];
        [self.view addSubview:_maskView];
    }];
}

-(void)hiddenNavBtn
{
    self.isHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.mmbView setFrame:CGRectMake(0, MD_H, MD_W, 100)];
        [_maskView removeFromSuperview];
    }];
}

-(void)handleShowView:(UITapGestureRecognizer *)tap
{
    if (_isHidden){
        [self showNavBtn];
    } else {
        [self hiddenNavBtn];
    }
}

-(void)prevPageView
{
    NSLog(@"prevPageView");
}

-(void)nextPageView:(UITapGestureRecognizer *)tap
{
    NSLog(@"nextPageView");
    [self.nextResponder becomeFirstResponder];
}

@end
