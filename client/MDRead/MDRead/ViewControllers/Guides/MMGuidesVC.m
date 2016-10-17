//
//  MMGuidesVC.m
//  MDRead
//
//  Created by midoks on 16/8/19.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMGuidesVC.h"
#import "RootVC.h"

@implementation MMGuidesVC


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake((MD_W - 100)/2, (MD_H - 100)/2, 100, 100)];
    [b setTitle:@"Welcome" forState:UIControlStateNormal];
    [b setBackgroundColor:[UIColor whiteColor]];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(setAppOks) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];

}

-(void)setAppOks
{
    [MMGuidesVC setAppOk];
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    w.rootViewController = [[RootVC alloc] init];
}


#pragma mark static method
+ (BOOL)isFristOpened
{
    NSString *v = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFristOpenedApp"];
    if( v!=nil && [v isEqual:@"isFristOpenedApp"]){
        return YES;
    }
    return NO;
}

+ (void)setAppOk
{
    [[NSUserDefaults standardUserDefaults] setObject:@"isFristOpenedApp" forKey:@"isFristOpenedApp"];
}

+ (void)setAppFail
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isFristOpenedApp"];
    
}

@end
