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
#import "MMButton.h"


@interface MMBookBaseLookVC ()

@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) MMBottomView *mmbView;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *moonDayView;
@property (nonatomic, strong) UIImageView *moonDayImageView;

@end

@implementation MMBookBaseLookVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.isHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initView];
    [self hiddenNavBtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initView {
    //导航设置
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    
    //普通设置
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"md_back"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self action:@selector(cancelButtonClick)];
    [leftButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //整个大遮罩 -- 退出
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MD_W, MD_H)];
    [_maskView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_maskView];
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenNavBtn)];
    [_maskView addGestureRecognizer:maskTap];
    
    //一些特殊设置
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(MD_W/3, 0, MD_W/3, MD_H)];
    [centerView setUserInteractionEnabled:YES];
    [centerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:centerView];
    
    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowView:)];
    [centerView addGestureRecognizer:tapGesture];
    
    //底部工具视图(自定义)
    _mmbView = [[MMBottomView alloc] initWithFrame:CGRectMake(0, MD_H - 50, MD_W, 50)];
    _mmbView.backgroundColor = [UIColor colorWithRed:200/255 green:200/255 blue:200/255 alpha:0.85];
    [self.view addSubview:_mmbView];
    
    UIButton *bList = [[MMButton alloc] initWithFrame:CGRectZero];
    [bList setImage:[UIImage imageNamed:@"md_r_dirlist"] forState:UIControlStateNormal];
    [bList addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [bList setTitle:@"目录" forState:UIControlStateNormal];
    
    UIButton *bProg = [[MMButton alloc] initWithFrame:CGRectZero];
    [bProg setImage:[UIImage imageNamed:@"md_r_progress"] forState:UIControlStateNormal];
    [bProg setTitle:@"进度" forState:UIControlStateNormal];
    
    UIButton *bAa = [[MMButton alloc] initWithFrame:CGRectZero];
    [bAa setImage:[UIImage imageNamed:@"md_r_aa"] forState:UIControlStateNormal];
    [bAa setTitle:@"选项" forState:UIControlStateNormal];
    
    UIButton *bShow = [[MMButton alloc] initWithFrame:CGRectZero];
    [bShow setImage:[UIImage imageNamed:@"md_r_show"] forState:UIControlStateNormal];
    [bShow setTitle:@"显示" forState:UIControlStateNormal];
    
    UIButton *bListen = [[MMButton alloc] initWithFrame:CGRectZero];
    [bListen setImage:[UIImage imageNamed:@"md_r_listen"] forState:UIControlStateNormal];
    [bListen setTitle:@"朗读" forState:UIControlStateNormal];
    
    _mmbView.item = [[NSMutableArray alloc] initWithObjects:bList, bProg, bAa, bShow, bListen, nil];
    
    
    //快捷(夜-白)选项
    _moonDayView = [[UIView alloc] initWithFrame:CGRectMake(MD_W, MD_H - 120, 48, 48)];
    _moonDayView.backgroundColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:0.85];
    _moonDayView.layer.cornerRadius = 24;
    [self.view addSubview:_moonDayView];
    
    UITapGestureRecognizer *tapDay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moonDaySwitch:)];
    [_moonDayView addGestureRecognizer:tapDay];
    
    NSString *moonDayName = @"md_r_day";
    if ([MMConfig getBoolOption:MDCONF_R_MOONDAY]) {
        moonDayName = @"md_r_day";
    } else {
        moonDayName = @"md_r_moon";
    }
    
    _moonDayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 24, 24)];
    _moonDayImageView.image = [UIImage imageNamed:moonDayName];
    [_moonDayView addSubview:_moonDayImageView];
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}

-(void)showNavBtn
{
    self.isHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.mmbView setFrame:CGRectMake(0, MD_H - 50, MD_W, 50)];
        [self.maskView setFrame:CGRectMake(0, 0, MD_W, MD_H)];
        [self.moonDayView setFrame:CGRectMake(MD_W - 60, MD_H - 120, 48, 48)];
    }];
}

-(void)hiddenNavBtn
{
    self.isHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.mmbView setFrame:CGRectMake(0, MD_H, MD_W, 50)];
        [self.maskView setFrame:CGRectMake(0, 0, MD_W, 0)];
        [self.moonDayView setFrame:CGRectMake(MD_W, MD_H - 120, 48, 48)];
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

#pragma mark - 日夜切换 -
-(void)moonDaySwitch:(UITapGestureRecognizer *)tap
{
    if ([MMConfig getBoolOption:MDCONF_R_MOONDAY]) {
        [MMConfig setOption:MDCONF_R_MOONDAY boolValue:NO];
        _moonDayImageView.image = [UIImage imageNamed:@"md_r_moon"];
    } else {
        [MMConfig setOption:MDCONF_R_MOONDAY boolValue:YES];
        _moonDayImageView.image = [UIImage imageNamed:@"md_r_day"];
    }
}

-(void)test
{
    NSLog(@"test");
}


@end
