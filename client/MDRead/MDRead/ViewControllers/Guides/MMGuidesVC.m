//
//  MMGuidesVC.m
//  MDRead
//
//  Created by midoks on 16/8/19.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMGuidesVC.h"

@implementation MMGuidesVC


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark static method
+ (BOOL)isFristOpen
{
    //[self setAppOk];
    NSString *v = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFristOpenApp"];
    MDLog(@"%@:%c", v, [v boolValue]);
    if(![v isEqual:@"isFristOpenApp"]){
        return YES;
    }
    return NO;
}

+ (void)setAppOk
{
    [[NSUserDefaults standardUserDefaults] setObject:@"isFristOpenApp" forKey:@"isFristOpenApp"];
}

+ (void)setAppFail
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isFristOpenApp"];
    
}

@end
