//
//  MMSimPageVCViewController.h
//  MDRead
//
//  Created by midoks on 16/9/30.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBookBaseLookVC.h"

@interface MMSimPageVC: MMBookBaseLookVC <UIPageViewControllerDataSource>

@property (nonatomic,strong)NSString *dataObject;

@end
