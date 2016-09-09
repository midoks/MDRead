//
//  RootViewController.m
//  MDRead
//
//  Created by midoks on 16/4/11.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "RootVC.h"

#import "MMCommon.h"

#import "MMSearchVC.h"
#import "MMBookMarkVC.h"
#import "MMSettingsVC.h"
#import "MMBookshelfViewController.h"

#import "MMSystemInfo.h"

#import "MMNovelApi.h"

@interface RootVC () <UITabBarControllerDelegate>

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    NSLog(@"%@", NSHomeDirectory());
    
    [self setTabBars];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) setTabBars {
    
    
    MMBookshelfViewController *bookshelf = [[MMBookshelfViewController alloc] init];
    UINavigationController *bookshelfNav = [[UINavigationController alloc] initWithRootViewController:bookshelf];
    UITabBarItem *mainIcon = [[UITabBarItem alloc] initWithTitle:@"书架" image:[UIImage imageNamed:@"mb_bookshelf"] tag:0];
    bookshelfNav.tabBarItem = mainIcon;
    [bookshelfNav.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [bookshelfNav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(2, 12)];
    
    
    MMSearchVC *search = [[MMSearchVC alloc] init];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:search];
    UITabBarItem *fileIcon = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"md_rearch"] tag:1];
    searchNav.tabBarItem = fileIcon;
    [searchNav.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [searchNav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(2, 12)];
    
    
    //[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:3];
    MMSettingsVC *bookSetting = [[MMSettingsVC alloc] init];
    UINavigationController *bookSettingNav = [[UINavigationController alloc] initWithRootViewController:bookSetting];
    UITabBarItem *novelIcon = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"md_setting"] tag:3];
    bookSettingNav.tabBarItem = novelIcon;
    [bookSettingNav.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [bookSettingNav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(2, 12)];
    
    NSArray *v = [[NSArray alloc] initWithObjects:bookshelfNav, searchNav, bookSettingNav,nil];
    [self setViewControllers:v animated:false];
    
    [[MMNovelApi shareInstance] addArgs:@"sysinfo" dic:[[MMSystemInfo shareInstance] getInfo]];
    [[MMNovelApi shareInstance] test:@"http://121.42.151.169/api" success:^{
        
        [MMCommon showMessage:@"验证通过"];
        
    } failure:^(int ret_code, NSString *ret_msg) {
        NSLog(@"%d:%@", ret_code, ret_msg);
        [MMCommon showMessage:ret_msg];
    }];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
//    NSLog(@"%ld", (long)item.tag);
//    if (item.tag == 1) {
//        
//        UIViewController *vc = [self.childViewControllers objectAtIndex:2];
//        
//        MMMainViewController *main = [[MMMainViewController alloc] init];
//        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:main];
//        
//        [vc presentViewController:mainNav animated:true completion:^{
//            
//        }];
//        
//        return;
//        
//    } else if (item.tag == 2){
//        
//        UIViewController *vc = [self.childViewControllers objectAtIndex:2];
//        
//        MMTextViewController *main = [[MMTextViewController alloc] init];
//        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:main];
//        
//        [vc presentViewController:mainNav animated:true completion:^{
//            
//        }];
//    
//        return;
//    }

}

@end