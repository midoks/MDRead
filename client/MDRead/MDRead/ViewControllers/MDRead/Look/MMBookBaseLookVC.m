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

@end

@implementation MMBookBaseLookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.isHidden = YES;
    
    [self initNavBtn];
    [self hiddenNavBtn];
    
    _mmbView = [[MMBottomView alloc] initWithFrame:CGRectMake(0, MD_H, MD_W, 100)];
    [self.view addSubview:_mmbView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initNavBtn
{
    //
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowView:)];
    [self.view addGestureRecognizer:_tapGesture];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"md_back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
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
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.mmbView setFrame:CGRectMake(0, MD_H - 100, MD_W, 100)];
    }];
}

-(void)hiddenNavBtn
{
    self.isHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.mmbView setFrame:CGRectMake(0, MD_H, MD_W, 100)];
    } completion:^(BOOL finished) {
    }];
}

-(void)handleShowView:(UITapGestureRecognizer *)tap
{
    if (self.navigationController.navigationBarHidden){
        [self showNavBtn];
    } else {
        [self hiddenNavBtn];
    }
}

-(void)prevPageView
{
    NSLog(@"prevPageView");
}

-(void)nextPageView
{
    NSLog(@"nextPageView");
}

@end
