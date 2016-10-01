//
//  MMSimPageVCViewController.m
//  MDRead
//
//  Created by midoks on 16/9/30.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSimPageVC.h"

@interface MMSimPageVC ()

@end

@implementation MMSimPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 100, 200, 200)];
    view.backgroundColor=[UIColor redColor];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    label.text=self.dataObject;
    [view addSubview:label];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
