//
//  AppDelegate.m
//  MDRead
//
//  Created by midoks on 16/4/9.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "AppDelegate.h"

#import "MTA.h"
#import "MTAConfig.h"
#import "RootVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置window属性(在AppDelegate中定义window属性),初始化windows的大小和位置
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [[RootVC alloc] init];
    [_window makeKeyAndVisible];

    
    [self appStat];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 统计 -
-(void)appStat
{
    [[MTAConfig getInstance] setDebugEnable:FALSE];
    //[[MTAConfig getInstance] setCustomerUserID:@"1234"];
    
    //[[MTAConfig getInstance] setMaxReportEventLength:1280];
    
    //Old Appkey "DemoApp@MTA"   IG4BJ2YGZ14F
    //[MTA startWithAppkey:@"IG4BJ2YGZ14F"];
    
    //[[MTAConfig getInstance] setCustomerUserID:@"1234"];
    
    //自定义ifa
    [[MTAConfig getInstance] setIfa:@"myIfa"];
    
    //push服务的deviceToken
    [[MTAConfig getInstance] setPushDeviceToken:@"myXGDeviceToken"];
    
    [[MTAConfig getInstance] setSmartReporting:false];
    
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
    
    //[[MTAConfig getInstance] setSmartReporting:FALSE];
    
    //自定义crash处理函数，可以获取到mta生成的crash信息
    void (^errorCallback)(NSString *) = ^(NSString * errorString)
    {
        NSLog(@"error_callback %@",errorString);
    };
    [[MTAConfig getInstance] setCrashCallback:errorCallback];
    
    //开发key
    [MTA startWithAppkey:@"I178YARHWX7Y"];
    [MTA reportQQ:@"627293072"];
    
    //[MTA reportAccount:@"5059175" type:1 ext:@"test"];
 
}

@end
