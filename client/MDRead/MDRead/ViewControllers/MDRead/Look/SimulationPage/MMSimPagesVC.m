//
//  MMSimPagesVC.m
//  MDRead
//
//  Created by midoks on 2016/10/15.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMSimPagesVC.h"

@interface MMSimPagesVC ()

@end

@implementation MMSimPagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) initPageView
{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 100, 200, 200)];
    view.backgroundColor=[UIColor redColor];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    label.text = self.dataObject;
    [view addSubview:label];
    [self.view addSubview:view];

}

@end
