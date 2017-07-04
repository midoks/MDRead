//
//  RootViewController.m
//  MDRead
//
//  Created by midoks on 16/4/11.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "RootVC.h"

#import "MMCommon.h"
#import "MMSystemInfo.h"
#import "MMNovelApi.h"

#import "MMSearchVC.h"
#import "MMBookMarkVC.h"
#import "MMSettingsVC.h"
#import "MMBookshelfVC.h"

#import "MMSourceModel.h"
#import "MMSourceListModel.h"



@interface RootVC () <UITabBarControllerDelegate>

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"%@", NSHomeDirectory());
    [self setTabBars];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setTabBars {
    
    
    MMBookshelfVC *bookshelf = [[MMBookshelfVC alloc] init];
    UINavigationController *bookshelfNav = [[UINavigationController alloc] initWithRootViewController:bookshelf];
    UITabBarItem *mainIcon = [[UITabBarItem alloc] initWithTitle:@"书架" image:[UIImage imageNamed:@"mb_bookshelf"] tag:0];
    bookshelfNav.tabBarItem = mainIcon;
    
    
    MMSearchVC *search = [[MMSearchVC alloc] init];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:search];
    UITabBarItem *fileIcon = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"md_rearch"] tag:1];
    searchNav.tabBarItem = fileIcon;
    
    //[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:3]; //系统图标
    MMSettingsVC *bookSetting = [[MMSettingsVC alloc] init];
    UINavigationController *bookSettingNav = [[UINavigationController alloc] initWithRootViewController:bookSetting];
    UITabBarItem *novelIcon = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"md_setting"] tag:3];
    bookSettingNav.tabBarItem = novelIcon;
    
    NSArray *v = [[NSArray alloc] initWithObjects:bookshelfNav, searchNav, bookSettingNav,nil];
    
    //隐藏文字
    for (int item = 0; item < [v count]; item++) {
        UINavigationController *uiNav = [v objectAtIndex:item];
        [uiNav.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        [uiNav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(2, 12)];
    }
    [self setViewControllers:v animated:NO];
    
    MMSourceListModel *list = [MMSourceListModel shareInstance];
    MMSourceModel *selected = [list getCurrent];
    
    if ( selected ) {
    
        NSString *url = selected.website;
        
        [[MMNovelApi shareInstance] addArgs:@"sysinfo" dic:[[MMSystemInfo shareInstance] getInfo]];
        [[MMNovelApi shareInstance] test:url success:^{
            
            [MMCommon showMessage:@"验证通过"];
            
        } failure:^(int ret_code, NSString *ret_msg) {
            MDLog(@"-- check api %d:%@ -- ", ret_code, ret_msg);
            [MMCommon showMessage:ret_msg];
        }];
    }
    
}

@end
