//
//  MMBookBaseLookVC.m
//  MDRead
//
//  Created by midoks on 2016/10/14.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookBaseLookVC.h"
#import "MMBottomView.h"
#import "MMConfig.h"

@interface MMBookBaseLookVC () 

@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) MMBottomView *mmbView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *moonDayView;
@property (nonatomic, strong) UIImageView *moonDayImageView;

@end

@implementation MMBookBaseLookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    //整个大遮罩 -- 退出
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MD_W, MD_H)];
    [_maskView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_maskView];
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenNavBtn)];
    [_maskView addGestureRecognizer:maskTap];
    
    //底部视图
    _mmbView = [[MMBottomView alloc] initWithFrame:CGRectMake(0, MD_H, MD_W, 100)];
    [self.view addSubview:_mmbView];
    
    //快捷(夜-白)选项
    _moonDayView = [[UIView alloc] initWithFrame:CGRectMake(MD_W, MD_H - 160, 50, 50)];
    _moonDayView.backgroundColor = [UIColor colorWithRed:42/255 green:42/255 blue:42/255 alpha:0.8];
    _moonDayView.layer.cornerRadius = 25;
    [self.view addSubview:_moonDayView];
    
    UITapGestureRecognizer *tapDay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moonDaySwitch:)];
    [_moonDayView addGestureRecognizer:tapDay];
    
    _moonDayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    if ([MMConfig getBoolOption:MDCONF_R_MOONDAY]) {
        _moonDayImageView.image = [UIImage imageNamed:@"md_day"];
    } else {
        _moonDayImageView.image = [UIImage imageNamed:@"md_moon"];
    }
    
    _moonDayImageView.userInteractionEnabled = YES;
    [_moonDayView addSubview:_moonDayImageView];
    

    //一些特殊设置
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(MD_W/3, 0, MD_W/3, MD_H)];
    [centerView setUserInteractionEnabled:YES];
    [centerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:centerView];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowView:)];
    [centerView addGestureRecognizer:_tapGesture];
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
        [self.maskView setFrame:CGRectMake(0, 0, MD_W, MD_H)];
        [self.moonDayView setFrame:CGRectMake(MD_W - 60, MD_H - 160, 50, 50)];
    }];
}

-(void)hiddenNavBtn
{
    self.isHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.mmbView setFrame:CGRectMake(0, MD_H, MD_W, 100)];
        [self.maskView setFrame:CGRectMake(0, 0, MD_W, 0)];
        [self.moonDayView setFrame:CGRectMake(MD_W, MD_H - 160, 50, 50)];
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


-(void)moonDaySwitch:(UITapGestureRecognizer *)tap
{
    if ([MMConfig getBoolOption:MDCONF_R_MOONDAY]) {
        [MMConfig setOption:MDCONF_R_MOONDAY boolValue:NO];
        _moonDayImageView.image = [UIImage imageNamed:@"md_moon"];
    } else {
        [MMConfig setOption:MDCONF_R_MOONDAY boolValue:YES];
        _moonDayImageView.image = [UIImage imageNamed:@"md_day"];
    }
}




@end
