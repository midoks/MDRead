//
//  MMBooklookViewController.m
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBooklookVC.h"

@interface MMBooklookVC ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation MMBooklookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initData
{

}

-(void)layoutUI
{
    
    [self initNavBtn];
    [self hiddenNavBtn];
    
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowView:)];
    [self.view addGestureRecognizer:_tapGesture];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)handleShowView:(UITapGestureRecognizer *)tap
{
    if (self.navigationController.navigationBarHidden){
        [self showNavBtn];
    } else {
        [self hiddenNavBtn];
    }
}


-(void)initNavBtn
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"md_back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)hiddenNavBtn
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)showNavBtn
{
    self.navigationController.navigationBarHidden = NO;
}


-(void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
